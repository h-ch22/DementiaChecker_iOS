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
    @State private var dragOffset = CGSize.zero
    @State private var answer = ""
    @State private var isRecording = false
    @State private var isPlayed = false
    @State private var timer = 0
    @State private var canvasView = PKCanvasView()
    
    @FocusState private var IsAnswerFieldFocused: Bool
    
    @StateObject private var helper = InspectionHelper()
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                HStack{
                    Text(String(format: "%02d:%02d", timer / 60, timer % 60))
                        .foregroundStyle(Color.accent)
                    
                    Spacer()
                    
                    Text("\(currentIndex + 1) / 28")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {dismiss()}){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.ultraThinMaterial)
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
                            dragOffset = CGSize.zero
                            canvasView = PKCanvasView()
                            helper.saveAnswer(answer: answer)
                            answer = ""
                            helper.resultText = ""
                            IsAnswerFieldFocused = false
                            isPlayed = false
                            currentIndex += 1
                        }
                    }){
                        Text("완료")
                    }
                } else if helper.isTTSAvailable(id: currentIndex) && !isPlayed{
                    Spacer().frame(height: 20)
                    
                    Button(action: {
                        helper.play(id: currentIndex)
                        isPlayed = true
                    }){
                        HStack{
                            Image(systemName: "play.fill")
                            Text("재생")
                        }
                    }
                }
                
                Spacer().frame(height: 20)
                
                if helper.getAnswerType(id: currentIndex) == .TEXT_FIELD{
                    HStack {
                        Image(systemName: "a.circle.fill")
                            .foregroundStyle(answer == "" ? Color.gray : Color.accent)
                        
                        TextField("정답을 입력하세요.", text: $answer)
                            .keyboardType(helper.getMMSETextFieldType(id: currentIndex))
                            .focused($IsAnswerFieldFocused)
                    }
                    .foregroundStyle(Color.accent)
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    
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
                                .foregroundStyle(Color.txt)
                            
                            Text(isRecording ? "녹음 중지" : "녹음 시작")
                                .foregroundStyle(Color.txt)
                            
                        }.padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Text(helper.resultText)
                        .foregroundStyle(Color.accent)
                    
                } else if helper.getAnswerType(id: currentIndex) == .DRAW{
                    MMSECanvasView(canvas: $canvasView)
                        .frame(height: 250)
                } else if helper.getAnswerType(id: currentIndex) == .PAPER{
                    if currentIndex == 22{
                        Rectangle()
                            .frame(width: 300, height: 300)
                            .foregroundStyle(
                                LinearGradient(stops: [
                                    Gradient.Stop(color: .red, location: 1.0 - abs(self.dragOffset.width) / 300),
                                    Gradient.Stop(color: .blue, location: abs(self.dragOffset.width) / 300)
                                ], startPoint: .topTrailing, endPoint: .topLeading)
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged{ gesture in
                                        self.dragOffset = gesture.translation
                                        print("start: \(1.0 - abs(self.dragOffset.width) / 300), end: \(abs(self.dragOffset.width) / 300)")
                                    }
                            )
                    } else if currentIndex == 23{
                        Rectangle()
                            .frame(width: 300, height: 300)
                            .foregroundStyle(
                                LinearGradient(stops: [
                                    Gradient.Stop(color: .red, location: 1.0 - abs(self.dragOffset.width) / 300),
                                    Gradient.Stop(color: .blue, location: abs(self.dragOffset.width) / 300)
                                ], startPoint: .topTrailing, endPoint: .topLeading)
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged{ gesture in
                                        self.dragOffset = gesture.translation
                                        print("start: \(1.0 - abs(self.dragOffset.width) / 300), end: \(abs(self.dragOffset.width) / 300)")
                                    }
                            )
                    }

                }
                
                Spacer()
                
                if helper.getAnswerType(id: currentIndex) != .DRAW{
                    Button(action: {
                        if currentIndex < 27{
                            dragOffset = CGSize.zero
                            canvasView = PKCanvasView()
                            helper.saveAnswer(answer: answer)
                            answer = ""
                            helper.resultText = ""
                            IsAnswerFieldFocused = false
                            isPlayed = false
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
                            .background(
                                .ultraThinMaterial
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
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
