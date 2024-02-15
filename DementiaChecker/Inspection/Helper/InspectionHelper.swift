//
//  InspectionHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
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
    
    private lazy var module_MMSE: TorchModule? = {
        if let filePath = Bundle.main.path(forResource: "cognitive_mobile", ofType: "ptl", inDirectory: "include"),
           let module_MMSE = TorchModule(fileAtPath: filePath){
            return module_MMSE
        } else{
            print("Failed to load model : MMSE")
            return nil
        }
    }()
    
    private lazy var module_LifeLog: TorchModule? = {
        if let filePath = Bundle.main.path(forResource: "walk_mobile", ofType: "ptl", inDirectory: "include"),
           let module_LifeLog = TorchModule(fileAtPath: filePath){
            return module_LifeLog
        } else{
            print("Failed to load model : LifeLog")
            return nil
        }
    }()
    
    private lazy var module_Sleep: TorchModule? = {
        if let filePath = Bundle.main.path(forResource: "sleep_mobile", ofType: "ptl", inDirectory: "include"),
           let module_Sleep = TorchModule(fileAtPath: filePath){
            return module_Sleep
        } else{
            print("Failed to load model : Sleep")
            return nil
        }
    }()
    
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
            return "올해가 몇 년인가요?"
            
        case 1:
            return "지금은 어떤 계절인가요?"
            
        case 2:
            return "오늘은 며칠인가요?"
            
        case 3:
            return "오늘은 무슨 요일인가요?"
            
        case 4:
            return "오늘은 몇 월인가요?"
            
        case 5:
            return "당신은 지금 어느 나라에 있나요?"
            
        case 6:
            return "당신은 지금 어느 시(도 / 주)에 있나요?"
            
        case 7:
            return "지금 계시는 장소는 어디인가요?"
            
        case 8:
            return "당신은 몇 층에 있나요?"
            
        case 9:
            return "당신은 어떤 일을 하나요?"
            
        case 10:
            return "지금부터 불러드리는 물건의 이름 세 개를 기억하고, 다시 말해주세요."
            
        case 11:
            return "100에서 7을 빼면 얼마인가요?"
            
        case 12..<16:
            return "거기에서 7을 빼면 얼마인가요?"
            
        case 16:
            return "10번 문항에서 불러드린 물건 중 첫번째 물건의 이름을 말해주세요."
            
        case 17:
            return "두번째 물건의 이름을 말해주세요."
            
        case 18:
            return "세번째 물건의 이름을 말해주세요."
            
        case 19, 20:
            return "보여드리는 물건의 이름은 무엇인가요?"
            
        case 21:
            return "들리는 말을 잘 듣고 따라해주세요."
            
        case 22:
            return "이 종이를 뒤집어보세요."
            
        case 23:
            return "이 종이를 반으로 접어보세요."
            
        case 24:
            return "이 종이를 표시된 곳으로 올려주세요."
            
        case 25:
            return "보여드리는 그림과 똑같이 그려주세요."
            
        case 26:
            return "아래 문장을 큰 소리로 읽고 쓰인 대로 해보세요."
            
        case 27:
            return "오늘의 날씨 또는 기분에 대해 자유롭게 작성해보세요."
            
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
                            self.scores.append(self.answerList[i] == "겨울" ? 2 : 1)
                            self.answers.append("겨울")
                        } else if month >= 3 && month < 6{
                            self.scores.append(self.answerList[i] == "봄" ? 2 : 1)
                            self.answers.append("봄")
                        } else if month >= 6 && month < 9{
                            self.scores.append(self.answerList[i] == "여름" ? 2 : 1)
                            self.answers.append("여름")
                        } else if month >= 9 && month < 12{
                            self.scores.append(self.answerList[i] == "가을" ? 2 : 1)
                            self.answers.append("가을")
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
                            self.answers.append("집")
                        } else if distanceToWork < 10{
                            self.answers.append("회사")
                        } else{
                            self.answers.append(building)
                        }
                                                
                        if self.answerList[i] == "집"{
                            self.scores.append(distanceToHome < 10 ? 2 : 1)
                        } else if self.answerList[i] == "회사"{
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
                            if self.answerList[i] == "" || self.answerList[i] == "무직" || self.answerList[i] == "없음"{
                                self.scores.append(2)
                            } else{
                                self.scores.append(1)
                            }
                        } else{
                            self.scores.append(job == self.answerList[i] ? 2 : 1)
                        }
                        
                        self.answers.append(job)
                        
                    case 10:
                        self.answers.append("비행기")
                        self.answers.append("연필")
                        self.answers.append("소나무")

                        if self.answerList[i].contains("비행기"){
                            self.scores.append(2)
                        } else{
                            self.scores.append(1)
                        }
                        
                        if self.answerList[i].contains("연필"){
                            self.scores.append(2)
                        } else{
                            self.scores.append(1)
                        }
                        
                        if self.answerList[i].contains("소나무"){
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
                        self.answers.append("비행기")
                        self.scores.append(self.answerList[i] == "비행기" ? 2 : 1)
                        
                    case 17:
                        self.answers.append("연필")
                        self.scores.append(self.answerList[i] == "연필" ? 2 : 1)
                        
                    case 18:
                        self.answers.append("소나무")
                        self.scores.append(self.answerList[i] == "소나무" ? 2 : 1)
                        
                    case 19:
                        self.answers.append("비행기")
                        self.scores.append(self.answerList[i] == "비행기" ? 2 : 1)
                        
                    case 20:
                        self.answers.append("시계")
                        self.scores.append(self.answerList[i] == "시계" ? 2 : 1)
                        
                    case 21:
                        self.answers.append("백문이불여일견")
                        self.scores.append(self.answerList[i].contains("백문이불여일견") ? 2 : 1)
                        
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
                guard self.module_MMSE != nil else{
                    completion(false)
                    return
                }
                
                guard let outputs = self.module_MMSE!.predict(data: UnsafeMutableRawPointer(&self.scores), outputSize: 3) else{
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

        healthKitHelper.getActivityEnergyBurned(start: start, end: Date(), completion: { activeCalorie in
            guard activeCalorie != nil else{
                completion(false)
                return
            }
            
            let usedAllCalrorie = activeCalorie * basalMetabolicRate
            
            self.healthKitHelper.getDistanceWalkingRunning(start: start, end: Date(), completion: { distance in
                guard distance != nil else{
                    completion(false)
                    return
                }
                
                self.healthKitHelper.getStepCount(start: start, end: Date(), completion: { stepCount in
                    guard stepCount != nil else{
                        completion(false)
                        return
                    }
                    
                    self.healthKitHelper.getActivityMinutes(start: start, end: Date(), completion: { activityMinutes in
                        guard activityMinutes != nil else{
                            completion(false)
                            return
                        }
                        
                        guard self.module_LifeLog != nil else{
                            completion(false)
                            return
                        }
                        
                        var data = [activeCalorie, usedAllCalrorie, distance, stepCount, activityMinutes]
                        
                        guard let outputs = self.module_LifeLog!.predict(data: UnsafeMutableRawPointer(&data), outputSize: 3) else{
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
                })
            })
        })
    }
    
    func predictSleep() -> Bool{
        guard self.module_Sleep != nil else{
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
