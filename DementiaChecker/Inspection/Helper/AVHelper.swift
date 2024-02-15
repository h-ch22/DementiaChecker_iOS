//
//  AVHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/16/24.
//

import Foundation
import AVFoundation
import Speech

class AVHelper: NSObject, ObservableObject, SFSpeechRecognizerDelegate{
    @Published var resultText = ""

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private let synthesizer = AVSpeechSynthesizer()
    
    override init(){
        super.init()
        speechRecognizer?.delegate = self
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
}
