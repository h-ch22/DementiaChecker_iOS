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

class InspectionHelper: NSObject, ObservableObject, SFSpeechRecognizerDelegate{
    private var answerList: [String] = []
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var resultText = ""
    
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
    
    func getAnswer(id: Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        switch id{
        case 0:
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: Date())
            
        case 1:
            dateFormatter.dateFormat = "mm"
            let monthAsString = dateFormatter.string(from: Date())
            let month = Int(monthAsString) ?? 0
            
            if month+1 == 12 || month+1 == 1 || month+1 == 2{
                return "겨울"
            } else if month+1 >= 3 && month+1 < 6{
                return "봄"
            } else if month+1 >= 6 && month+1 < 9{
                return "여름"
            } else if month+1 >= 9 && month+1 < 12{
                return "가을"
            }
            
        case 2:
            dateFormatter.dateFormat = "dd"
            
            return dateFormatter.string(from: Date())
            
        case 3:
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: Date())
            
        case 4:
            dateFormatter.dateFormat = "mm"
            return dateFormatter.string(from: Date())
            
        default:
            return ""
        }
        
        return ""
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
            
        case 22..<26:
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
