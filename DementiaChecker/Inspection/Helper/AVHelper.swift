//
//  AVHelper.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/16/24.
//

import Foundation
import AVFoundation
import Speech

class AVHelper: NSObject, ObservableObject, SFSpeechRecognizerDelegate{
    @Published var resultText = ""

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
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
        
        do{
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func startRecording(){
        audioEngine.inputNode.removeTap(onBus: 0)
        
        if audioEngine.isRunning{
            endAudio()
        }
        
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
        let utterance = AVSpeechUtterance(string: isSample ? "Hi, this sentence is playing for speaker test on Dementia Checker. If this sounds too loud or too small, please adjust the system volume." : self.getTTSString(id: id))
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
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
            return "Airplane Pencil Pine tree"
            
        case 21:
            return "A picture is worth a thousand words"
            
        default:
            return ""
        }
    }
}
