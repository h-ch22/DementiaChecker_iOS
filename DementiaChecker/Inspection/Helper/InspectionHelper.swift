//
//  InspectionHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import Foundation
import UIKit
import AVFoundation
import Speech
import CoreLocation
import Alamofire
import SwiftyJSON

class InspectionHelper: NSObject, ObservableObject, SFSpeechRecognizerDelegate, CLLocationManagerDelegate{
    private var answerList: [String] = []
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private let synthesizer = AVSpeechSynthesizer()
    private let locationManager = CLLocationManager()
    private let API_KEY = "wg1lmr2uds"
    private let API_SECRET = "etkEdOhXHoQ3wOF628HGAwSPHdSaoi8SvmU5RpGJ"
    private let RGC_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"
    
    @Published var resultText = ""
    @Published var scores = [Int]()
    @Published var answers = [String]()
    
    override init(){
        super.init()
        speechRecognizer?.delegate = self
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
    
    func grading() -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        for i in 0..<answerList.count{
            switch i{
            case 0:
                dateFormatter.dateFormat = "yyyy"
                answers.append(dateFormatter.string(from: Date()))
                scores.append(dateFormatter.string(from: Date()) == answerList[i] ? 1 : 0)
                
            case 1:
                dateFormatter.dateFormat = "mm"
                let monthAsString = dateFormatter.string(from: Date())
                let month = Int(monthAsString) ?? 0
                
                if month+1 == 12 || month+1 == 1 || month+1 == 2{
                    scores.append(answerList[i] == "겨울" ? 1 : 0)
                    answers.append("겨울")
                } else if month+1 >= 3 && month+1 < 6{
                    scores.append(answerList[i] == "봄" ? 1 : 0)
                    answers.append("봄")
                } else if month+1 >= 6 && month+1 < 9{
                    scores.append(answerList[i] == "여름" ? 1 : 0)
                    answers.append("여름")
                } else if month+1 >= 9 && month+1 < 12{
                    scores.append(answerList[i] == "가을" ? 1 : 0)
                    answers.append("가을")
                }
                
            case 2:
                dateFormatter.dateFormat = "dd"
                answers.append(dateFormatter.string(from: Date()))
                scores.append(answerList[i] == dateFormatter.string(from: Date()) ? 1 : 0)
                
            case 3:
                dateFormatter.dateFormat = "EEEE"
                answers.append(dateFormatter.string(from: Date()))
                scores.append(answerList[i] == dateFormatter.string(from: Date()) ? 1 : 0)
                
            case 4:
                dateFormatter.dateFormat = "mm"
                let monthAsString = dateFormatter.string(from: Date())
                let month = Int(monthAsString) ?? 0
                
                answers.append(String(month + 1))
                scores.append(answerList[i] == String(month + 1) ? 1 : 0)
                
            case 5:
                if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: Locale.current.regionCode) {
                    scores.append(answerList[i] == name ? 1 : 0)
                    answers.append(name)
                } else {
                    scores.append(answerList[i] == Locale.current.region?.identifier ? 1 : 0)
                    answers.append(Locale.current.region?.identifier ?? "")
                }
                
            case 6:
                let latLng = self.getCurrentLatLng()
                self.reverseGeoCode(requestType: "State", lat: String(latLng?.coordinate.latitude ?? 0.0), lng: String(latLng?.coordinate.longitude ?? 0.0)){ answerState in
                    guard let answerState = answerState else{ return }
                    
                    self.answers.append(answerState ?? "")
                    self.scores.append(self.answerList[i] == answerState ? 1 : 0)
                }

            case 7:
                let latLng = self.getCurrentLatLng()
                self.reverseGeoCode(requestType: "Building", lat: String(latLng?.coordinate.latitude ?? 0.0), lng: String(latLng?.coordinate.longitude ?? 0.0)){ answerBuilding in
                    guard let answerBuilding = answerBuilding else{ return }
                    
                    if answerBuilding != ""{
                        self.scores.append(self.answerList[i] == answerBuilding ? 1 : 0)
                        self.answers.append(answerBuilding ?? "")
                    } else{
                        self.scores.append(self.answerList[i] != "" ? 1 : 0)
                        self.answers.append("")
                    }
                }

                
            case 8:
                let latLng = self.getCurrentLatLng()
                let altitude = Double(latLng?.altitude ?? 0.0)
                
                scores.append(answerList[i] == String(Int(altitude / 240)) ? 1 : 0)
                answers.append(String(Int(altitude / 240)))
                
            case 9:
                scores.append(answerList[i] != "" ? 1 : 0)
                answers.append("")
                
            case 10:
                answers.append("비행기 연필 소나무")
                
                if answerList[i].contains("비행기") && answerList[i].contains("연필") && answerList[i].contains("소나무"){
                    scores.append(1)
                } else{
                    scores.append(0)
                }
                
            case 11:
                answers.append("93")
                scores.append(answerList[i] == "93" ? 1 : 0)

            case 12:
                answers.append("86")
                scores.append(answerList[i] == "86" ? 1 : 0)

            case 13:
                answers.append("79")
                scores.append(answerList[i] == "79" ? 1 : 0)
                
            case 14:
                answers.append("72")
                scores.append(answerList[i] == "72" ? 1 : 0)
                
            case 15:
                answers.append("65")
                scores.append(answerList[i] == "65" ? 1 : 0)
                
            case 16:
                answers.append("비행기")
                scores.append(answerList[i] == "비행기" ? 1 : 0)
                
            case 17:
                answers.append("연필")
                scores.append(answerList[i] == "연필" ? 1 : 0)
                
            case 18:
                answers.append("소나무")
                scores.append(answerList[i] == "소나무" ? 1 : 0)
                
            case 19:
                answers.append("비행기")
                scores.append(answerList[i] == "비행기" ? 1 : 0)
                
            case 20:
                answers.append("시계")
                scores.append(answerList[i] == "시계" ? 1 : 0)
                
            case 21:
                answers.append("백문이 불여일견")
                scores.append(answerList[i].contains("백문이 불여일견") ? 1 : 0)
                
            case 22, 23, 24, 25, 26:
                answers.append("")
                scores.append(answerList[i] == "1" ? 1 : 0)
                
            case 27:
                answers.append("")
                scores.append(answerList[i] != "" ? 1 : 0)
                
            default:
                break
            }
            
            print(answers)
        }
        
        return true
    }
    
    private func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) -> CLLocation? {
        if CLLocationManager.locationServicesEnabled(){
            return locationManager.location
        }
        
        return nil
    }
    
    private func getCurrentLatLng() -> CLLocation?{
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        return self.locationManagerDidChangeAuthorization(locationManager)
    }
    
    private func reverseGeoCode(requestType: String, lat: String, lng: String, completion: @escaping(_ answer: String?) -> Void){
        let header_key = HTTPHeader(name : "X-NCP-APIGW-API-KEY-ID", value : API_KEY)
        let header_secret = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API_SECRET)
        let headers = HTTPHeaders([header_key, header_secret])
        
        let lat_double = Double(lat)!
        let lng_double = Double(lng)!
                
        let parameters : Parameters = [
            "coords" : "\(lng_double),\(lat_double)",
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
                    
                    if requestType == "State"{
                        print(state)
                        completion(state)
                    } else if requestType == "Building"{
                        print(building)
                        completion(building)
                    }
                    
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
    
    func getMMSETextFieldType(id: Int) -> UIKeyboardType{
        switch id{
        case 0, 2, 4, 8, 11, 12, 13, 14, 15:
            return UIKeyboardType.numberPad
            
        default:
            return UIKeyboardType.default
        }
    }
    
    func isTTSAvailable(id: Int) -> Bool{
        switch id{
        case 10, 21: return true
        default: return false
        }
    }
    
    private func getTTSString(id: Int) -> String{
        switch id{
        case 10:
            return "비행기 연필 소나무"
            
        case 21:
            return "백문이 불여일견"
            
        default:
            return ""
        }
    }
    
    func play(id: Int, isSample: Bool = false){
        let utterance = AVSpeechUtterance(string: isSample ? "안녕하세요. 이 문장은 Dementia Checker에서 스피커 테스트를 위해 재생되는 문장입니다. 이 소리가 너무 크거나 작게 들리면 시스템 볼륨을 조절해주세요." : self.getTTSString(id: id))
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.2
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
    
    func stop(){
        synthesizer.stopSpeaking(at: .immediate)
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
    
    func getAudioEngineRunning() -> Bool{
        return audioEngine.isRunning ? true : false
    }
    
    func endAudio(){
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func startRecording(){
        audioEngine.inputNode.removeTap(onBus: 0)
        
        if recognitionTask != nil{
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch{
            print(error.localizedDescription)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else{
            fatalError("Cannot initalize recognition request.")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil{
                self.resultText = result?.bestTranscription.formattedString ?? ""
                
                isFinal = (result?.isFinal)!
            }
            
            if isFinal{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){ (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
        } catch{
            print(error.localizedDescription)
        }
    }
}
