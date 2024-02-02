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

class UserManagement: ObservableObject{
    @Published var userInfo: UserInfoModel? = nil
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
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
    
    func signUp(email: String, password: String, name: String, phone: String, birthday: String, patientEmail: String, userType: String, completion: @escaping(_ result: UserManagementAlertType?) -> Void){
        auth.createUser(withEmail: email, password: password){ _, error in
            if error != nil{
                completion(.UNKNOWN_ERROR)
                return
            }
            
            self.setUserInfo(email: email, name: name, phone: phone, birthday: birthday, patientEmail: patientEmail, userType: userType, completion: { result in
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
    
    func setUserInfo(email: String, name: String, phone: String, birthday: String, patientEmail: String, userType: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").setData([
            "email": AES256Util.encrypt(string: email),
            "name": AES256Util.encrypt(string: name),
            "phone": AES256Util.encrypt(string: phone),
            "birthday": AES256Util.encrypt(string: birthday),
            "patientEmail": AES256Util.encrypt(string: patientEmail),
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
}
