//
//  InspectionHelper.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Accelerate
import CoreLocation

class InspectionHelper: NSObject, ObservableObject{
    @Published var scores = [Int]()
    @Published var answers = [String]()
    @Published var answerList: [String] = []
    
    @Published var inspectionResult: InspectionResultDataModel = InspectionResultDataModel(type: .NORMAL, percentageOfNormal: 0.0, percentageOfMCI: 0.0, percentageOfDementia: 0.0)
    @Published var mmseData: ClassInspectionResultDataModel = ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 0.0, percentageOfMCI: 0.0, percentageOfDementia: 0.0)
    @Published var sleepData: ClassInspectionResultDataModel = ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 0.0, percentageOfMCI: 0.0, percentageOfDementia: 0.0)
    @Published var lifeLogData: ClassInspectionResultDataModel = ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 0.0, percentageOfMCI: 0.0, percentageOfDementia: 0.0)
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let labels = ["NORMAL", "MCI", "DEMENTIA"]
    private let fileManager = FileManager.default
    private let healthKitHelper = HealthKitHelper()
    
    private func getModule(type: InspectionTypeModel) -> TorchModule?{
        let resource = switch type {
        case .MMSE:
            "cognitive_mobile"
            
        case .SLEEP:
            "sleep_mobile"
            
        case .WALK:
            "walk_mobile"
        }
        
        if let filePath = Bundle.main.path(forResource: resource, ofType: "ptl", inDirectory: "include"),
           let module = TorchModule(fileAtPath: filePath){
            return module
        } else{
            print("Failed to load model : Sleep")
            return nil
        }
    }
    
    private func getInspectionType(type: String) -> InspectionResultTypeModel{
        switch type{
        case "NORMAL":
            return .NORMAL
            
        case "MCI":
            return .MCI
            
        case "DEMENTIA":
            return .DEMENTIA
            
        default:
            return .NORMAL
        }
    }
    
    func uploadResult(completion: @escaping(_ result: Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm:ss"
        
        db.collection("Users").document(auth.currentUser?.uid ?? "").collection("Results").document(dateFormatter.string(from: Date())).setData([
            "type": AES256Util.encrypt(string: inspectionResult.getTypeAsString()),
            "percentOfNormal": inspectionResult.percentageOfNormal,
            "percentOfMCI": inspectionResult.percentageOfMCI,
            "percentOfDementia": inspectionResult.percentageOfDementia,
            "MMSEType": AES256Util.encrypt(string: mmseData.getTypeAsString()),
            "MMSEScores": scores,
            "percentOfMMSENormal": mmseData.percentageOfNormal,
            "percentOfMMSEMCI": mmseData.percentageOfMCI,
            "percentOfMMSEDementia": mmseData.percentageOfDementia,
            "lifeLogType": AES256Util.encrypt(string: lifeLogData.getTypeAsString()),
            "percentOfLifeLogNormal": lifeLogData.percentageOfNormal,
            "percentOfLifeLogMCI": lifeLogData.percentageOfMCI,
            "percentOfLifeLogDementia": lifeLogData.percentageOfDementia,
            "sleepType": AES256Util.encrypt(string: sleepData.getTypeAsString()),
            "percentOfSleepNormal": sleepData.percentageOfNormal,
            "percentOfSleepMCI": sleepData.percentageOfMCI,
            "percentOfSleepDementia": sleepData.percentageOfDementia,
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
    
    func getResult(id: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").collection("Results").document(id).getDocument(){(document, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if document != nil{
                let type = AES256Util.decrypt(encoded: document?.get("type") as? String ?? "")
                let percentOfNormal = document?.get("percentOfNormal") as? Double ?? 0.0
                let percentOfMCI = document?.get("percentOfMCI") as? Double ?? 0.0
                let percentOfDementia = document?.get("percentOfDementia") as? Double ?? 0.0
                
                let MMSEType = AES256Util.decrypt(encoded: document?.get("MMSEType") as? String ?? "")
                let MMSEScores = document?.get("MMSEScores") as? [Int] ?? []
                
                let percentOfMMSENormal = document?.get("percentOfMMSENormal") as? Double ?? 0.0
                let percentOfMMSEMCI = document?.get("percentOfMMSEMCI") as? Double ?? 0.0
                let percentOfMMSEDementia = document?.get("percentOfMMSEDementia") as? Double ?? 0.0
                
                let lifeLogType = AES256Util.decrypt(encoded: document?.get("lifeLogType") as? String ?? "")
                let percentOfLifeLogNormal = document?.get("percentOfLifeLogNormal") as? Double ?? 0.0
                let percentOfLifeLogMCI = document?.get("percentOfLifeLogMCI") as? Double ?? 0.0
                let percentOfLifeLogDementia = document?.get("percentOfLifeLogDementia") as? Double ?? 0.0
                
                let sleepType = AES256Util.decrypt(encoded: document?.get("sleepType") as? String ?? "")
                let percentOfSleepNormal = document?.get("percentOfSleepNormal") as? Double ?? 0.0
                let percentOfSleepMCI = document?.get("percentOfSleepMCI") as? Double ?? 0.0
                let percentOfSleepDementia = document?.get("percentOfSleepDementia") as? Double ?? 0.0
                
                self.inspectionResult = InspectionResultDataModel(type: self.getInspectionType(type: type),
                                                                  percentageOfNormal: Float(percentOfNormal),
                                                                  percentageOfMCI: Float(percentOfMCI),
                                                                  percentageOfDementia: Float(percentOfDementia))
                
                self.scores = MMSEScores
                
                self.mmseData = ClassInspectionResultDataModel(max: self.getInspectionType(type: MMSEType), percentageOfNormal: Float(percentOfMMSENormal), percentageOfMCI: Float(percentOfMMSEMCI), percentageOfDementia: Float(percentOfMMSEDementia))
                self.lifeLogData = ClassInspectionResultDataModel(max: self.getInspectionType(type: lifeLogType), percentageOfNormal: Float(percentOfLifeLogNormal), percentageOfMCI: Float(percentOfLifeLogMCI), percentageOfDementia: Float(percentOfLifeLogDementia))
                self.sleepData = ClassInspectionResultDataModel(max: self.getInspectionType(type: sleepType), percentageOfNormal: Float(percentOfSleepNormal), percentageOfMCI: Float(percentOfSleepMCI), percentageOfDementia: Float(percentOfSleepDementia))
                
                completion(true)
                return
            }
        }
    }
    
    func getLatestResult(completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").collection("Results").getDocuments(){(querySnapshot, error) in
            if error != nil{
                completion(false)
                return
            }
            
            if querySnapshot != nil{
                if !querySnapshot!.isEmpty{
                    let document = querySnapshot!.documents[querySnapshot!.documents.count - 1]
                    
                    let type = AES256Util.decrypt(encoded: document.get("type") as? String ?? "")
                    let percentOfNormal = document.get("percentOfNormal") as? Double ?? 0.0
                    let percentOfMCI = document.get("percentOfMCI") as? Double ?? 0.0
                    let percentOfDementia = document.get("percentOfDementia") as? Double ?? 0.0
                    
                    self.inspectionResult = InspectionResultDataModel(type: self.getInspectionType(type: type),
                                                                      percentageOfNormal: Float(percentOfNormal),
                                                                      percentageOfMCI: Float(percentOfMCI),
                                                                      percentageOfDementia: Float(percentOfDementia))
                    
                    completion(true)
                    return
                }
            }
            
            completion(false)
            return
        }
    }
    
    func getDataList(completion: @escaping(_ result: [String]?) -> Void){
        var ids = [String]()
        
        db.collection("Users").document(auth.currentUser?.uid ?? "").collection("Results").getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion([])
                return
            }
            
            if querySnapshot != nil{
                if !querySnapshot!.isEmpty{
                    for document in querySnapshot!.documents{
                        ids.append(document.documentID)
                    }
                    
                    completion(ids)
                    return
                } else{
                    completion([])
                    return
                }
                
            } else{
                completion([])
                return
            }
        }
    }
    
    private func topK(scores: [NSNumber], labels: [String], count: Int) -> [PredictResult]?{
        let zippedResults = zip(labels.indices, scores)
        let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(count)
        
        let result = sortedResults.map { PredictResult(score: $0.1.floatValue, label: labels[$0.0]) }
        return result
    }
    
    private func getMaxType(result: [PredictResult]) -> InspectionResultTypeModel?{
        var max: Float = 0.0
        var label = ""
        
        for prediction in result{
            if prediction.score > max{
                max = prediction.score
                label = prediction.label
            }
        }
        
        switch label{
        case "NORMAL": return .NORMAL
        case "MCI": return .MCI
        case "DEMENTIA": return .DEMENTIA
        default: return nil
        }
    }
    
    private func getPercentageByTypes(result: [PredictResult]) -> (Float, Float, Float){
        var percentageOfDementia: Float = 0.0
        var percentageOfMCI: Float = 0.0
        var percentageOfNormal: Float = 0.0
        
        for prediction in result{
            if prediction.label == "NORMAL"{
                percentageOfNormal = prediction.score
            } else if prediction.label == "MCI"{
                percentageOfMCI = prediction.score
            } else if prediction.label == "DEMENTIA"{
                percentageOfDementia = prediction.score
            }
        }
        
        return (percentageOfNormal, percentageOfMCI, percentageOfDementia)
    }
    
    func getMMSEQuestion(id: Int) -> String{
        switch id{
        case 0:
            return "What year is it?"
            
        case 1:
            return "What season is it now?"
            
        case 2:
            return "What day is it today?"
            
        case 3:
            return "What day of the week is it today?"
            
        case 4:
            return "What month is it today?"
            
        case 5:
            return "Which country are you in right now?"
            
        case 6:
            return "Which city/state are you in right now?"
            
        case 7:
            return "Where are you right now?"
            
        case 8:
            return "Which floor are you on?"
            
        case 9:
            return "What are you doing right now?"
            
        case 10:
            return "Please remember and repeat the names of three items I will say."
            
        case 11:
            return "What is 100 minus 7?"
            
        case 12..<16:
            return "What is the result when subtracting 7 from there?"
            
        case 16:
            return "Please say the name of the first item you remembered from question 10."
            
        case 17:
            return "Please say the name of the second item."
            
        case 18:
            return "Please say the name of the third item."
            
        case 19, 20:
            return "What is the name of the item shown?"
            
        case 21:
            return "Listen carefully and repeat the words."
            
        case 22:
            return "Turn this paper over."
            
        case 23:
            return "Fold this paper in half."
            
        case 24:
            return "Place this paper where indicated."
            
        case 25:
            return "Draw the picture exactly as shown."
            
        case 26:
            return "Read the sentence aloud and write it down as it is."
            
        case 27:
            return "Write freely about today's weather or mood."
            
        default:
            return ""
        }
        
    }
    
    func grading(job: String, homeLatLng: String, workLatLng: String, completion: @escaping(_ result: Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let locationHelper = LocationHelper()
        let latLng = locationHelper.getCurrentLatLng()
        let lat = String(latLng?.coordinate.latitude ?? 0.0)
        let lng = String(latLng?.coordinate.longitude ?? 0.0)
        
        let altitude = Double(latLng?.altitude ?? 0.0)
        
        locationHelper.reverseGeoCode(requestType: "State", lat: lat, lng: lng, completion: { state in
            guard let state = state else{return}
            
            locationHelper.reverseGeoCode(requestType: "Building", lat: lat, lng: lng, completion: { building in
                guard let building = building else{return}
                
                for i in 0..<self.answerList.count{
                    switch i{
                    case 0:
                        dateFormatter.dateFormat = "yyyy"
                        self.answers.append(dateFormatter.string(from: Date()))
                        self.scores.append(dateFormatter.string(from: Date()) == self.answerList[i] ? 2 : 1)
                        
                    case 1:
                        dateFormatter.dateFormat = "MM"
                        let monthAsString = dateFormatter.string(from: Date())
                        let month = Int(monthAsString) ?? 0
                        
                        if month == 12 || month == 1 || month == 2{
                            self.scores.append(self.answerList[i] == "Winter" ? 2 : 1)
                            self.answers.append("Winter")
                        } else if month >= 3 && month < 6{
                            self.scores.append(self.answerList[i] == "Spring" ? 2 : 1)
                            self.answers.append("Spring")
                        } else if month >= 6 && month < 9{
                            self.scores.append(self.answerList[i] == "Summer" ? 2 : 1)
                            self.answers.append("Summer")
                        } else if month >= 9 && month < 12{
                            self.scores.append(self.answerList[i] == "Autumn" ? 2 : 1)
                            self.answers.append("Autumn")
                        }
                        
                    case 2:
                        dateFormatter.dateFormat = "dd"
                        self.answers.append(dateFormatter.string(from: Date()))
                        self.scores.append(self.answerList[i] == dateFormatter.string(from: Date()) ? 2 : 1)
                        
                    case 3:
                        dateFormatter.dateFormat = "EEEE"
                        self.answers.append(dateFormatter.string(from: Date()))
                        self.scores.append(self.answerList[i] == dateFormatter.string(from: Date()) ? 2 : 1)
                        
                    case 4:
                        dateFormatter.dateFormat = "MM"
                        let monthAsString = dateFormatter.string(from: Date())
                        let month = Int(monthAsString) ?? 0
                        
                        self.answers.append(String(month))
                        self.scores.append(self.answerList[i] == String(month) ? 2 : 1)
                        
                    case 5:
                        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: Locale.current.regionCode) {
                            self.scores.append(self.answerList[i] == name ? 2 : 1)
                            self.answers.append(name)
                        } else {
                            self.scores.append(self.answerList[i] == Locale.current.region?.identifier ? 2 : 1)
                            self.answers.append(Locale.current.region?.identifier ?? "")
                        }
                        
                    case 6:
                        self.answers.append(state ?? "")
                        self.scores.append(self.answerList[i] == state ? 2 : 1)
                        
                    case 7:
                        let homeLatLngSplited = homeLatLng.split(separator: ", ")
                        
                        let distanceToHome = CLLocationCoordinate2D(latitude: latLng?.coordinate.latitude ?? 0.0, longitude: latLng?.coordinate.longitude ?? 0.0)
                            .distance(from: CLLocationCoordinate2D(latitude: Double(homeLatLngSplited[0] ?? "0.0") ?? 0.0, longitude: Double(homeLatLngSplited[1] as? String ?? "0.0") ?? 0.0))
                        
                        let workLatLngSplited = workLatLng.split(separator: ", ")
                        
                        let distanceToWork = CLLocationCoordinate2D(latitude: latLng?.coordinate.latitude ?? 0.0, longitude: latLng?.coordinate.longitude ?? 0.0)
                            .distance(from: CLLocationCoordinate2D(latitude: Double(workLatLngSplited[0] ?? "0.0") ?? 0.0, longitude: Double(workLatLngSplited[1] as? String ?? "0.0") ?? 0.0))
                        
                        if distanceToHome < 10{
                            self.answers.append("Home")
                        } else if distanceToWork < 10{
                            self.answers.append("Company")
                        } else{
                            self.answers.append(building)
                        }
                        
                        if self.answerList[i] == "Home"{
                            self.scores.append(distanceToHome < 10 ? 2 : 1)
                        } else if self.answerList[i] == "Company"{
                            self.scores.append(distanceToWork < 10 ? 2 : 1)
                        } else{
                            if building != ""{
                                self.scores.append(self.answerList[i] == building ? 2 : 1)
                            } else{
                                self.scores.append(self.answerList[i] != "" ? 2 : 1)
                            }
                        }
                        
                    case 8:
                        self.scores.append(self.answerList[i] == String(Int(altitude / 240)) ? 2 : 1)
                        self.answers.append(String(Int(altitude / 240)))
                        
                    case 9:
                        if job == ""{
                            if self.answerList[i] == "" || self.answerList[i] == "Inoccupation" || self.answerList[i] == "None" || self.answerList[i] == "Between jobs" || self.answerList[i] == "Out of work"{
                                self.scores.append(2)
                            } else{
                                self.scores.append(1)
                            }
                        } else{
                            self.scores.append(job == self.answerList[i] ? 2 : 1)
                        }
                        
                        self.answers.append(job)
                        
                    case 10:
                        self.answers.append("Airplane")
                        self.answers.append("Pencil")
                        self.answers.append("Pine tree")
                        
                        if self.answerList[i].contains("Airplane"){
                            self.scores.append(2)
                        } else{
                            self.scores.append(1)
                        }
                        
                        if self.answerList[i].contains("Pencil"){
                            self.scores.append(2)
                        } else{
                            self.scores.append(1)
                        }
                        
                        if self.answerList[i].contains("Pine tree"){
                            self.scores.append(2)
                        } else{
                            self.scores.append(1)
                        }
                        
                    case 11:
                        self.answers.append("93")
                        self.scores.append(self.answerList[i] == "93" ? 2 : 1)
                        
                    case 12:
                        self.answers.append("86")
                        self.scores.append(self.answerList[i] == "86" ? 2 : 1)
                        
                    case 13:
                        self.answers.append("79")
                        self.scores.append(self.answerList[i] == "79" ? 2 : 1)
                        
                    case 14:
                        self.answers.append("72")
                        self.scores.append(self.answerList[i] == "72" ? 2 : 1)
                        
                    case 15:
                        self.answers.append("65")
                        self.scores.append(self.answerList[i] == "65" ? 2 : 1)
                        self.scores.append(0)
                        
                    case 16:
                        self.answers.append("Airplane")
                        self.scores.append(self.answerList[i] == "Airplane" ? 2 : 1)
                        
                    case 17:
                        self.answers.append("Pencil")
                        self.scores.append(self.answerList[i] == "Pencil" ? 2 : 1)
                        
                    case 18:
                        self.answers.append("Pine tree")
                        self.scores.append(self.answerList[i] == "Pine tree" ? 2 : 1)
                        
                    case 19:
                        self.answers.append("Airplane")
                        self.scores.append(self.answerList[i] == "Airplane" ? 2 : 1)
                        
                    case 20:
                        self.answers.append("Clock")
                        self.scores.append(self.answerList[i] == "Clock" ? 2 : 1)
                        
                    case 21:
                        self.answers.append("A picture is worth a thousand words")
                        self.scores.append(self.answerList[i].contains("A picture is worth a thousand words") ? 2 : 1)
                        
                    case 22, 23, 24, 26:
                        self.answers.append("")
                        self.scores.append(self.answerList[i] == "True" ? 2 : 1)
                        
                    case 25:
                        self.answers.append("")
                        let similarity = self.compareImages()
                        
                        self.scores.append(similarity ?? 0.0 < 0.7 ? 1 : 2)
                        
                    case 27:
                        self.answers.append("")
                        self.scores.append(self.answerList[i] != "" ? 2 : 1)
                        
                    default:
                        break
                    }
                    
                }
                
                self.scores.append(self.getTotalScore())
                
                let module_MMSE = self.getModule(type: .MMSE)
                
                guard module_MMSE != nil else{
                    completion(false)
                    return
                }
                
                guard let outputs = module_MMSE!.predict(data: UnsafeMutableRawPointer(&self.scores), outputSize: 3) else{
                    completion(false)
                    return
                }
                
                let result = self.topK(scores: outputs, labels: self.labels, count: 3)
                
                guard result != nil else{
                    completion(false)
                    return
                }
                
                let (percentageOfNormal, percentageOfMCI, percentageOfDementia) = self.getPercentageByTypes(result: result!)
                let max = self.getMaxType(result: result!)
                
                self.mmseData = ClassInspectionResultDataModel(max: (max == nil ? .NORMAL : max) ?? .NORMAL, percentageOfNormal: percentageOfNormal, percentageOfMCI: percentageOfMCI, percentageOfDementia: percentageOfDementia)
                
                completion(true)
                return
            })
        })
    }
    
    func predictLifeLog(tall: Double, weight: Double, age: Double, gender: String, completion: @escaping(_ result: Bool?) -> Void){
        let basalMetabolicRate = gender == "Male" ? Double(66.47) + (13.75 * weight) + (5.0 * tall) - (6.76 * age) : Double(655.1) + (9.56 * weight) + (1.85 * tall) - (4.68 * age)
        let start = Calendar.current.startOfDay(for: Date())
        
        healthKitHelper.updateData(start: start, end: Date(), completion: { _ in
            let usedAllCalrorie = self.healthKitHelper.activityEnergy * basalMetabolicRate
            
            let module_LifeLog = self.getModule(type: .WALK)
            
            guard module_LifeLog != nil else{
                completion(false)
                return
            }
            
            var data = [self.healthKitHelper.activityEnergy, usedAllCalrorie, self.healthKitHelper.distanceWalkingRunning, self.healthKitHelper.steps, self.healthKitHelper.activityMinute]
            
            guard let outputs = module_LifeLog!.predict(data: UnsafeMutableRawPointer(&data), outputSize: 3) else{
                completion(false)
                return
            }
            
            let result = self.topK(scores: outputs, labels: self.labels, count: 3)
            
            guard result != nil else{
                completion(false)
                return
            }
            
            let (percentageOfNormal, percentageOfMCI, percentageOfDementia) = self.getPercentageByTypes(result: result!)
            let max = self.getMaxType(result: result!)
            
            self.lifeLogData = ClassInspectionResultDataModel(max: (max == nil ? .NORMAL : max) ?? .NORMAL, percentageOfNormal: percentageOfNormal, percentageOfMCI: percentageOfMCI, percentageOfDementia: percentageOfDementia)
            
            completion(true)
            return
        })
    }
    
    func predictSleep() -> Bool{
        let module_sleep = self.getModule(type: .SLEEP)
        
        guard module_sleep != nil else{
            return false
        }
        
        return true
    }
    
    func calculateInspectionResult(completion: @escaping(_ result: Bool?) -> Void){
        let percentageOfNormal: Float = (mmseData.percentageOfNormal * Float(0.5)) + (lifeLogData.percentageOfNormal * Float(0.25)) + (sleepData.percentageOfNormal * Float(0.25))
        let percentageOfMCI: Float = (mmseData.percentageOfMCI * Float(0.5)) + (lifeLogData.percentageOfMCI * Float(0.25)) + (sleepData.percentageOfMCI * Float(0.25))
        let percentageOfDementia: Float = (mmseData.percentageOfDementia * Float(0.5)) + (lifeLogData.percentageOfDementia * Float(0.25)) + (sleepData.percentageOfDementia * Float(0.25))
        
        var max: InspectionResultTypeModel = .NORMAL
        
        if percentageOfNormal > percentageOfMCI{
            max = .NORMAL
            
            if percentageOfDementia > percentageOfNormal{
                max = .DEMENTIA
            } else{
                max = .NORMAL
            }
        } else{
            max = .MCI
            
            if percentageOfDementia > percentageOfMCI{
                max = .DEMENTIA
            } else{
                max = .MCI
            }
        }
        
        self.inspectionResult = InspectionResultDataModel(type: max, percentageOfNormal: percentageOfNormal, percentageOfMCI: percentageOfMCI, percentageOfDementia: percentageOfDementia)
        
        self.uploadResult(completion: { result in
            guard let result = result else{return}
            
            completion(result)
            return
        })
    }
    
    private func getDocumentsDirectory() -> URL?{
        do{
            let paths = try FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            return paths[0]
        } catch{
            print(error)
            return nil
        }
        
    }
    
    func saveImage(image: UIImage) -> Bool{
        do{
            let directory = getDocumentsDirectory()?.appendingPathComponent("img_drew.png")
            
            if directory == nil{
                print("directory: nil")
                return false
            }
            
            if fileManager.fileExists(atPath: directory!.absoluteString){
                do{
                    try fileManager.removeItem(atPath: directory!.absoluteString)
                } catch let error{
                    print(error)
                    return false
                }
            }
            
            if let imageData = image.pngData(){
                try imageData.write(to: directory!)
                return true
            } else{
                print("cannot extract image data")
                return false
            }
        } catch{
            print(error)
            return false
        }
    }
    
    private func compareImages() -> Double?{
        let image_original = UIImage(named: "img_draw")
        let directory = getDocumentsDirectory()?.appendingPathComponent("img_drew.png")
        
        let image_drew = UIImage(contentsOfFile: (directory?.path())!) ?? nil
        
        if image_original != nil && image_drew != nil{
            guard let imageData1 = getGrayscaleData(from: image_original!), let imageData2 = getGrayscaleData(from: image_drew!) else{
                print("cannot get grayscale data")
                return nil
            }
            
            let width = Int(image_original!.size.width)
            let height = Int(image_original!.size.height)
            
            var floatData1 = [Float](repeating: 0, count: width * height)
            var floatData2 = [Float](repeating: 0, count: width * height)
            var resultData = [Float](repeating: 0, count: width * height)
            
            vDSP.convertElements(of: imageData1, to: &floatData1)
            vDSP.convertElements(of: imageData2, to: &floatData2)
            vDSP.subtract(floatData2, floatData1, result: &resultData)
            vDSP.absolute(resultData, result: &resultData)
            vDSP.clip(resultData, to: 0...1, result: &resultData)
            
            let sum: Float = vDSP.sum(resultData)
            let ratio = Double(sum) / Double(width * height)
            
            let similarity = 1 - ratio
            return similarity
        } else{
            print("image_original or image_drew is nil")
            return nil
        }
    }
    
    private func getGrayscaleData(from image: UIImage) -> [UInt8]? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let bitsPerComponent = 8
        let bytesPerPixel = 1
        let bytesPerRow = width * bytesPerPixel
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.none.rawValue
        
        var imageData = [UInt8](repeating: 0, count: width * height)
        
        guard let context = CGContext(
            data: &imageData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        return imageData
    }
    
    private func getTotalScore() -> Int{
        var total = 0
        
        for score in scores{
            if score == 2{
                total += 1
            }
        }
        
        return total
    }
    
    func getMMSETextFieldType(id: Int) -> UIKeyboardType{
        switch id{
        case 0, 2, 4, 8, 11, 12, 13, 14, 15:
            return UIKeyboardType.numberPad
            
        default:
            return UIKeyboardType.default
        }
    }
    
    func getAnswerType(id: Int) -> MMSEAnswerTypeModel{
        switch id{
        case 0..<9:
            return .TEXT_FIELD
            
        case 10:
            return .AUDIO
            
        case 11..<16:
            return .TEXT_FIELD
            
        case 16..<19:
            return .AUDIO
            
        case 19, 20:
            return .TEXT_FIELD
            
        case 21:
            return .AUDIO
            
        case 22..<25:
            return .PAPER
            
        case 25:
            return .DRAW
            
        case 26:
            return .AUDIO
            
        case 27:
            return .TEXT_FIELD
            
        default:
            return .TEXT_FIELD
        }
    }
    
    func saveAnswer(answer: String){
        answerList.append(answer)
    }
}
