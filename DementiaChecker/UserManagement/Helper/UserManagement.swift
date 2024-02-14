//
//  UserManagement.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import Alamofire
import SwiftyJSON

class UserManagement: ObservableObject{
    @Published var userInfo: UserInfoModel? = nil
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private let API_KEY = "wg1lmr2uds"
    private let API_SECRET = "etkEdOhXHoQ3wOF628HGAwSPHdSaoi8SvmU5RpGJ"
    private let GC_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
    private let RGC_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"

    func signIn(email: String, password: String, completion: @escaping(_ result: UserManagementAlertType?) -> Void){
        auth.signIn(withEmail: email, password: password){ _, error in
            if error != nil{
                completion(.UNKNOWN_USER)
                return
            }
            
            self.getUserInfo(){ result in
                guard let result = result else{return}
                
                completion(result ? .SUCCESS : .UNKNOWN_ERROR)
                return
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, phone: String, birthday: String, patientEmail: String, homeAddress: String, job: String, workAddress: String, tall: String, weight: String, userType: String, gender: String, completion: @escaping(_ result: UserManagementAlertType?) -> Void){
        
        self.geoCode(address: homeAddress, completion: { homeGeocode in
            guard let homeGeocode = homeGeocode else{return}
            
            if homeGeocode == ", "{
                completion(.UNKNOWN_ERROR)
                return
            }
            
            if workAddress != ""{
                self.geoCode(address: workAddress, completion: { workGeocode in
                    guard let workGeocode = workGeocode else{return}
                    
                    if workGeocode == ", "{
                        completion(.UNKNOWN_ERROR)
                        return
                    }
                    
                    self.auth.createUser(withEmail: email, password: password){ _, error in
                        if error != nil{
                            completion(.UNKNOWN_ERROR)
                            return
                        }
                        
                        self.setUserInfo(email: email, name: name, phone: phone, birthday: birthday, patientEmail: patientEmail, userType: userType, homeAddress: homeGeocode, job: job, workAddress: workGeocode, tall: tall, weight: weight, gender: gender, completion: { result in
                            guard let result = result else{return}
                            
                            if result{
                                self.getUserInfo(){ getResult in
                                    guard let getResult = getResult else{return}
                                    completion(getResult ? .SUCCESS : .UNKNOWN_ERROR)
                                }
                            } else{
                                self.auth.currentUser?.delete(){_ in
                                    completion(.UNKNOWN_ERROR)
                                    return
                                }
                            }
                        })
                    }
                })
            }
        })
    }
    
    private func geoCode(address: String, completion: @escaping(_ result: String?) -> Void){
        let header_key = HTTPHeader(name : "X-NCP-APIGW-API-KEY-ID", value : API_KEY)
        let header_secret = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API_SECRET)
        let headers = HTTPHeaders([header_key, header_secret])
        
        let parameters: Parameters = [
            "query": address
        ]
        
        let request = AF.request(GC_URL, method: .get, parameters: parameters, headers: headers)

        request.validate().responseJSON(){response in
            switch response.result {
                
            case .success(let success):
                let json = JSON(success)
                
                let x = json["addresses"][0]["x"].string ?? ""
                let y = json["addresses"][0]["y"].string ?? ""
                                
                completion("\(x), \(y)")

            case .failure(let failure):
                print(failure)
                completion("")
                return
                
            default:
                completion("")
                fatalError()
            }
        }
    }
    
    func reverseGeocode(geoCode: String, completion: @escaping(_ result: String?) -> Void){
        let header_key = HTTPHeader(name : "X-NCP-APIGW-API-KEY-ID", value : API_KEY)
        let header_secret = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API_SECRET)
        let headers = HTTPHeaders([header_key, header_secret])
        print(geoCode)
        
        let parameters : Parameters = [
            "coords" : geoCode,
            "output" : "json",
            "orders" : "addr,admcode,roadaddr"
        ]
        
        let alamo = AF.request(RGC_URL, method: .get, parameters: parameters, headers: headers)
        
        alamo.validate().responseJSON(){response in
                switch response.result{
                case .success(let value as [String : Any]):
                    let json = JSON(value)
                    let data = json["results"]
                    let state = data[0]["region"]["area1"]["name"].string ?? ""
                    let address = data[0]["region"]["area2"]["name"].string ?? ""
                    let address_detail = data[0]["region"]["area3"]["name"].string ?? ""
                    let roadName = data[2]["land"]["name"].string ?? ""
                    let road = data[2]["land"]["number1"].string ?? ""
                    var roadCode = data[2]["land"]["number2"].string ?? ""
                    let building = data[2]["land"]["addition0"]["value"].string ?? ""
                    
                    if roadCode != ""{
                        roadCode = "-" + roadCode
                    }
                    
                    completion("\(state) \(address) \(roadName) \(road)\(roadCode) \(building)")
                    return
                    
                case .failure(let error) :
                    print(error)
                    completion("")
                    
                    return
                    
                default:
                    completion("")
                    fatalError()
                }
                
            }
    }
    
    func searchPatient(email: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").whereField("email", isEqualTo: AES256Util.encrypt(string: email)).getDocuments(){ querySnapshot, error in
            if error != nil{
                completion(false)
                return
            }
            
            completion(querySnapshot?.documents.count ?? 0 > 0)
        }
    }
    
    func setUserInfo(email: String, name: String, phone: String, birthday: String, patientEmail: String, userType: String, homeAddress: String, job: String, workAddress: String, tall: String, weight: String, gender: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").setData([
            "email": AES256Util.encrypt(string: email),
            "name": AES256Util.encrypt(string: name),
            "phone": AES256Util.encrypt(string: phone),
            "birthday": AES256Util.encrypt(string: birthday),
            "patientEmail": AES256Util.encrypt(string: patientEmail),
            "homeAddress": AES256Util.encrypt(string: homeAddress),
            "job": AES256Util.encrypt(string: job),
            "workAddress": AES256Util.encrypt(string: workAddress),
            "tall": AES256Util.encrypt(string: tall),
            "weight": AES256Util.encrypt(string: weight),
            "gender": AES256Util.encrypt(string: gender),
            "userType": userType
        ]){ error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
    
    private func getUserInfo(completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").getDocument(){ document, error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if document != nil{
                self.userInfo = UserInfoModel(email: AES256Util.decrypt(encoded: document?.get("email") as? String ?? ""),
                                              name: AES256Util.decrypt(encoded: document?.get("name") as? String ?? ""),
                                              phone: AES256Util.decrypt(encoded: document?.get("phone") as? String ?? ""),
                                              birthDay: AES256Util.decrypt(encoded: document?.get("birthday") as? String ?? ""),
                                              patientEmail: AES256Util.decrypt(encoded: document?.get("patientEmail") as? String ?? ""),
                                              homeAddress: AES256Util.decrypt(encoded: document?.get("homeAddress") as? String ?? ""),
                                              job: AES256Util.decrypt(encoded: document?.get("job") as? String ?? ""),
                                              workAddress: AES256Util.decrypt(encoded: document?.get("workAddress") as? String ?? ""),
                                              tall: AES256Util.decrypt(encoded: document?.get("tall") as? String ?? ""),
                                              weight: AES256Util.decrypt(encoded: document?.get("weight") as? String ?? ""),
                                              gender: AES256Util.decrypt(encoded: document?.get("gender") as? String ?? ""),
                                              userType: document?.get("userType") as? String ?? "PATIENT" == "PATIENT" ? .PATIENT : .GUARDIAN)
                
                completion(true)
                return
            }
        }
    }
    
    func getGuardians(completion: @escaping(_ result: [UserInfoModel]?) -> Void){
        db.collection("Users").whereField("patientEmail", isEqualTo: AES256Util.encrypt(string: userInfo?.email ?? "")).getDocuments(){(querySnapshot, error) in
            var results: [UserInfoModel] = []
            
            if error != nil{
                completion(results)
                return
            }
            
            if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    results.append(UserInfoModel(email: AES256Util.decrypt(encoded: document.get("email") as? String ?? ""),
                                                 name: AES256Util.decrypt(encoded: document.get("name") as? String ?? ""),
                                                 phone: AES256Util.decrypt(encoded: document.get("phone") as? String ?? ""),
                                                 birthDay: AES256Util.decrypt(encoded: document.get("birthday") as? String ?? ""),
                                                 patientEmail: AES256Util.decrypt(encoded: document.get("patientEmail") as? String ?? ""),
                                                 homeAddress: AES256Util.decrypt(encoded: document.get("homeAddress") as? String ?? ""),
                                                 job: AES256Util.decrypt(encoded: document.get("job") as? String ?? ""),
                                                 workAddress: AES256Util.decrypt(encoded: document.get("workAddress") as? String ?? ""),
                                                 tall: AES256Util.decrypt(encoded: document.get("tall") as? String ?? ""),
                                                 weight: AES256Util.decrypt(encoded: document.get("weight") as? String ?? ""),
                                                 gender: AES256Util.decrypt(encoded: document.get("gender") as? String ?? ""),
                                                 userType: document.get("userType") as? String ?? "PATIENT" == "PATIENT" ? .PATIENT : .GUARDIAN))
                }
                
                completion(results)
                return
            } else{
                completion(results)
                return
            }
        }
    }
    
    func setInheritanceGuardian(email: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").updateData(
            [
                "inheritanceGuardians": FieldValue.arrayUnion([AES256Util.encrypt(string: email)])
            ]
        ){error in
            if error != nil{
                print(error?.localizedDescription)
            }
            
            completion(error==nil)
        }
    }
    
    func removeInheritanceGuardian(email: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").updateData(
            [
                "inheritanceGuardians": FieldValue.arrayRemove([AES256Util.encrypt(string: email)])
            ]
        ){error in
            if error != nil{
                print(error?.localizedDescription)
            }
            
            completion(error==nil)
        }
    }
    
    func getAge() -> Int{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        let calendar = Calendar.current
        
        let birthDay = dateFormatter.date(from: userInfo?.birthDay ?? "19991. 01. 01.")
        let ageComponents = calendar.dateComponents([.year], from: birthDay!, to: now)
        return ageComponents.year!
    }
    
    func getInheritanceGuardian(completion: @escaping(_ result: [UserInfoModel]?) -> Void){
        var inheritanceGuardians: [UserInfoModel] = []
        
        db.collection("Users").document(auth.currentUser?.uid ?? "").getDocument(){(document, error) in
            if error != nil{
                error?.localizedDescription
                completion(inheritanceGuardians)
                return
            }
            
            var results: [String] = document?.get("inheritanceGuardians") as? [String] ?? []
            
            if !results.isEmpty{
                for result in results{
                    self.db.collection("Users").whereField("email", isEqualTo: result).getDocuments(){(querySnapshot, error) in
                        if error != nil{
                            completion(inheritanceGuardians)
                            return
                        }
                        
                        if querySnapshot != nil{
                            for document in querySnapshot!.documents{
                                inheritanceGuardians.append(UserInfoModel(email: AES256Util.decrypt(encoded: document.get("email") as? String ?? ""),
                                                                          name: AES256Util.decrypt(encoded: document.get("name") as? String ?? ""),
                                                                          phone: AES256Util.decrypt(encoded: document.get("phone") as? String ?? ""),
                                                                          birthDay: AES256Util.decrypt(encoded: document.get("birthday") as? String ?? ""),
                                                                          patientEmail: document.get("patientEmail") as? String ?? "" != "" ? AES256Util.decrypt(encoded: document.get("patientEmail") as? String ?? "") : "",
                                                                          homeAddress: AES256Util.decrypt(encoded: document.get("homeAddress") as? String ?? ""),
                                                                          job: AES256Util.decrypt(encoded: document.get("job") as? String ?? ""),
                                                                          workAddress: AES256Util.decrypt(encoded: document.get("workAddress") as? String ?? ""),
                                                                          tall: AES256Util.decrypt(encoded: document.get("tall") as? String ?? ""),
                                                                          weight: AES256Util.decrypt(encoded: document.get("weight") as? String ?? ""),
                                                                          gender: AES256Util.decrypt(encoded: document.get("gender") as? String ?? ""),
                                                                          userType: document.get("userType") as? String ?? "PATIENT" == "PATIENT" ? .PATIENT : .GUARDIAN))
                            }
                            
                            completion(inheritanceGuardians)
                            return
                        } else{
                            completion(inheritanceGuardians)
                            return
                        }
                    }
                }
            } else{
                completion(inheritanceGuardians)
                return
            }
            
            
        }
    }
    
    func sendResetPasswordMail(email: String, completion: @escaping(_ result: Bool?) -> Void){
        auth.sendPasswordReset(withEmail: email){ error in
            if error != nil{
                print(error?.localizedDescription)
            }
            
            completion(error == nil)
            return
        }
    }
    
    func signOut(completion: @escaping(_ result: Bool?) -> Void){
        do{
            try auth.signOut()
            completion(true)
            return
        } catch let error as NSError{
            print(error)
            completion(false)
            return
        }
    }
    
    func cancelMembership(completion: @escaping(_ result: Bool?) -> Void){
        let uid = auth.currentUser?.uid
        
        self.db.collection("Users").document(uid ?? "").delete(){ _ in
            self.auth.currentUser?.delete{ error in
                if let error = error{
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                completion(true)
                return
            }
        }
    }
}
