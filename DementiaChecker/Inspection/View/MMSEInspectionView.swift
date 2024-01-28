//
//  MMSEInspectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI
import PencilKit

struct MMSEInspectionView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentIndex = 0
    @State private var answer = ""
    @State private var isRecording = false
    @State private var timer = 0
    @State private var canvasView = PKCanvasView()
    
    @FocusState private var IsAnswerFieldFocused: Bool
    
    @StateObject private var helper = InspectionHelper()
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                HStack{
                    Text(String(format: "%02d:%02d", timer / 60, timer % 60))
                        .foregroundStyle(Color.accentColor)
                    
                    Spacer()
                    
                    Text("\(currentIndex + 1) / 28")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {dismiss()}){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.gray)
                    }
                }
                
                Spacer()
                
                Text(helper.getMMSEQuestion(id: currentIndex))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                if helper.getAnswerType(id: currentIndex) == .DRAW{
                    Spacer().frame(height: 20)
                    
                    Button(action: {
                        if currentIndex < 27{
                            canvasView = PKCanvasView()
                            helper.saveAnswer(answer: answer)
                            answer = ""
                            helper.resultText = ""
                            IsAnswerFieldFocused = false
                            currentIndex += 1
                        }
                    }){
                        Text("완료")
                    }
                }
                
                Spacer().frame(height: 20)
                
                if helper.getAnswerType(id: currentIndex) == .TEXT_FIELD{
                    TextField("정답을 입력하세요.", text: $answer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(helper.getMMSETextFieldType(id: currentIndex))
                        .focused($IsAnswerFieldFocused)
                } else if helper.getAnswerType(id: currentIndex) == .AUDIO{
                    Button(action: {
                        if !isRecording{
                            if helper.getAudioEngineRunning(){
                                helper.endAudio()
                            }
                            
                            helper.resultText = ""
                            helper.startRecording()
                            isRecording = true
                        } else{
                            answer = helper.resultText
                            helper.endAudio()
                            isRecording = false
                        }
                    }){
                        VStack{
                            Image(systemName: isRecording ? "stop.circle.fill" : "waveform")
                            Text(isRecording ? "녹음 중지" : "녹음 시작")
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn).shadow(radius: 5))
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Text(helper.resultText)
                        .foregroundStyle(Color.accentColor)
                    
                } else if helper.getAnswerType(id: currentIndex) == .DRAW{
                    MMSECanvasView(canvas: $canvasView)
                        .frame(height: 250)
                }
                
                Spacer()
                
                if helper.getAnswerType(id: currentIndex) != .DRAW{
                    Button(action: {
                        if currentIndex < 27{
                            canvasView = PKCanvasView()
                            helper.saveAnswer(answer: answer)
                            answer = ""
                            helper.resultText = ""
                            IsAnswerFieldFocused = false
                            currentIndex += 1
                        }
                    }){
                        HStack{
                            Text(currentIndex < 27 ? "다음 문항" : "검사 종료")
                                .foregroundStyle(Color.white)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                        }.padding(20)
                            .padding([.horizontal], 80)
                            .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color.accentColor)
                                .shadow(radius: 5))
                    }
                }

            }.padding(20)
                .animation(.easeInOut)
                .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
                        self.timer += 1
                    }
                }
        }
    }
}

#Preview {
    MMSEInspectionView()
}
