//
//  MMSEInspectionView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
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
    @State private var changeView = false
    @State private var showResultView = false
    @State private var isSuccess = false
    
    @State private var x: CGFloat = 50
    @State private var y: CGFloat = 400
    
    @State private var currentInspectingType = InspectionTypeModel.MMSE
    @State private var errorType : InspectionTypeModel? = nil
    @State private var isDone = false
    
    @FocusState private var IsAnswerFieldFocused: Bool
    
    @StateObject var helper: InspectionHelper
    @StateObject private var avHelper = AVHelper()
    @EnvironmentObject var userManagement: UserManagement
    
    var drag: some Gesture{
        DragGesture()
            .onChanged{ value in
                self.x = value.location.x
                self.y = value.location.y
                
                if abs(x - 250) > 20 && abs(y - 150) > 20{
                    isSuccess = true
                }
            }
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            if changeView{
                VStack{
                    if !isDone{
                        Text(errorType == nil ? "Test in Progress" : "Test Failed")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text(errorType == nil ? "Dementia Checker is diagnosing dementia based on the user's cognitive function and lifestyle data.\nPlease wait for a moment." : "There was a problem diagnosing dementia based on the user's data.\nPlease try again later or check the data.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.gray)
                    } else{
                        Text("Test Completed")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Dementia Checker has completed diagnosing dementia based on the user's data.\nPress the button below to check the test result.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Spacer()
                    
                    HStack{
                        if errorType != .MMSE{
                            switch currentInspectingType {
                            case .MMSE:
                                ProgressView()
                                
                            case .SLEEP, .WALK, .UNIVERSAL:
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                        } else if errorType == .MMSE{
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.orange)
                        }
                        
                        Spacer().frame(width: 10)
                        
                        Text("Cognitive Function Test")
                            .foregroundStyle(currentInspectingType == .MMSE ? Color.txt : Color.gray)
                            .fontWeight(currentInspectingType == .MMSE ? .semibold : .regular)
                            .font(currentInspectingType == .MMSE ? .headline : .caption)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack{
                        if errorType != .WALK{
                            switch currentInspectingType {
                            case .MMSE:
                                EmptyView()
                                
                            case .WALK:
                                ProgressView()

                            case .SLEEP, .UNIVERSAL:
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                        } else if errorType == .WALK{
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.orange)
                        }

                        Spacer().frame(width: 10)

                        Text("LifeLog Data Test")
                            .foregroundStyle(currentInspectingType == .WALK ? Color.txt : Color.gray)
                            .fontWeight(currentInspectingType == .WALK ? .semibold : .regular)
                            .font(currentInspectingType == .WALK ? .headline : .caption)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack{
                        if errorType != .SLEEP && errorType != .WALK{
                            switch currentInspectingType {
                            case .MMSE, .WALK:
                                EmptyView()
                                
                            case .SLEEP:
                                ProgressView()
                                
                            case .UNIVERSAL:
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                        } else if errorType == .SLEEP{
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.orange)
                        }

                        Spacer().frame(width: 10)
                        
                        Text("Sleep Pattern Data Test")
                            .foregroundStyle(currentInspectingType == .SLEEP ? Color.txt : Color.gray)
                            .fontWeight(currentInspectingType == .SLEEP ? .semibold : .regular)
                            .font(currentInspectingType == .SLEEP ? .headline : .caption)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack{
                        if isDone{
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.green)
                        } else if errorType != .UNIVERSAL && errorType != .SLEEP{
                            switch currentInspectingType {
                            case .MMSE, .WALK, .SLEEP:
                                EmptyView()
                                
                            case .UNIVERSAL:
                                ProgressView()
                            }
                        } else if errorType == .UNIVERSAL{
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.orange)
                        }

                        Spacer().frame(width: 10)
                        
                        if !isDone{
                            Text("Universal Test")
                                .foregroundStyle(currentInspectingType == .UNIVERSAL && errorType != .SLEEP ? Color.txt : Color.gray)
                                .fontWeight(currentInspectingType == .UNIVERSAL && errorType != .SLEEP ? .semibold : .regular)
                                .font(currentInspectingType == .UNIVERSAL && errorType != .SLEEP ? .headline : .caption)
                        } else{
                            Text("Universal Test")
                                .foregroundStyle(Color.gray)
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    if errorType != nil{
                        Button(action: {
                            dismiss()
                        }){
                            HStack{
                                Spacer()

                                Text("Back to Previous Screen")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()

                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                    } else if isDone{
                        Button(action: {
                            showResultView = true
                        }){
                            HStack{
                                Spacer()

                                Text("Check Test Result")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()

                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                        
                        Spacer().frame(height: 20)
                        
                        Button(action: {
                            dismiss()
                        }){
                            Text("Close")
                                .foregroundStyle(Color.txt)
                        }
                    }
                    
                }.padding(20)
                .animation(.easeInOut)
                .fullScreenCover(isPresented: $showResultView, content: {
                    InspectionResultsView(data: helper.inspectionResult, mmseData: helper.mmseData, sleepData: helper.sleepData, lifeLogData: helper.lifeLogData, MMSEResult: helper.scores, MMSEAnswer: helper.answers, answerList: helper.answerList)
                })
                .onAppear{
                    DispatchQueue.global().async{
                        helper.grading(job: userManagement.userInfo?.job ?? "",
                                                    homeLatLng: userManagement.userInfo?.homeAddress ?? "",
                                       workLatLng: userManagement.userInfo?.workAddress ?? ""){ MMSEResult in
                            guard let MMSEResult = MMSEResult else{return}
                            
                            if MMSEResult{
                                currentInspectingType = .WALK
                                
                                helper.predictLifeLog(completion: { lifeLogResult in
                                    guard let lifeLogResult = lifeLogResult else{return}
                                    
                                    if lifeLogResult{
                                        currentInspectingType = .SLEEP
                                        
                                        helper.predictSleep(){ sleepResult in
                                            guard let sleepResult = sleepResult else{return}
                                            
                                            if sleepResult{
                                                currentInspectingType = .UNIVERSAL

                                                helper.predictUniversal(){ universalResult in
                                                    guard let universalResult = universalResult else{
                                                        return
                                                    }
                                                    
                                                    if universalResult{
                                                        isDone = true
                                                    } else{
                                                        currentInspectingType = .UNIVERSAL
                                                        errorType = .UNIVERSAL
                                                    }
                                                }
                                            } else{
                                                currentInspectingType = .SLEEP
                                                errorType = .SLEEP
                                            }
                                        }
                                        

                                    } else{
                                        print("An error occured while predicing lifelog")
                                        currentInspectingType = .WALK
                                        errorType = .WALK
                                    }
                                })
                            } else{
                                currentInspectingType = .MMSE
                                errorType = .MMSE
                            }
                        }
                        

                    }
                }
            } else{
                VStack{
                    HStack{
                        Text(String(format: "%02d:%02d", timer / 60, timer % 60))
                            .foregroundStyle(Color.accent)
                        
                        Spacer()
                        
                        Text("\(currentIndex + 1) / 28")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {dismiss()}){
                            Image(systemName: "xmark")
                                .foregroundStyle(Color.txt)
                        }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
                    }
                    
                    Spacer()
                    
                    if currentIndex == 19{
                        Image("img_airplane")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                    } else if currentIndex == 20{
                        Image("img_clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                    } else if currentIndex == 25{
                        Image("img_draw")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                    }
                    
                    Text(helper.getMMSEQuestion(id: currentIndex))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    if helper.getAnswerType(id: currentIndex) == .DRAW{
                        Spacer().frame(height: 20)
                        
                        Button(action: {
                            if currentIndex < 27{
                                if currentIndex == 25{
                                    let _ = helper.saveImage(image: canvasView.asUIImage().resized(to: CGSize(width: 400, height: 400)))
                                }
                                
                                dragOffset = CGSize.zero
                                canvasView = PKCanvasView()
                                helper.saveAnswer(answer: answer)
                                answer = ""
                                avHelper.resultText = ""
                                IsAnswerFieldFocused = false
                                isPlayed = false
                                currentIndex += 1
                            }
                        }){
                            Text("Complete")
                        }
                    } else if avHelper.isTTSAvailable(id: currentIndex) && !isPlayed{
                        Spacer().frame(height: 20)
                        
                        Button(action: {
                            avHelper.play(id: currentIndex)
                            isPlayed = true
                        }){
                            HStack{
                                Image(systemName: "play.fill")
                                Text("Play")
                            }
                        }
                    } else if currentIndex == 24{
                        Rectangle()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.red)
                            .position(CGPoint(x: x, y: y))
                            .gesture(drag)
                        
                        if abs(x - 250) > 20 && abs(y - 150) > 20{
                            Rectangle()
                                .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [CGFloat](), dashPhase: 0.2))
                                .frame(width: 100, height: 100)
                                .position(CGPoint(x: 250, y: -150))
                        }
                    } else if currentIndex == 26{
                        Text("Close your eyes for more than 2 seconds.")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.red)
                            .padding(20)
                            .background(
                                Rectangle()
                                    .strokeBorder(Color.red)
                            )
                    }
                    
                    Spacer().frame(height: 20)
                    
                    if helper.getAnswerType(id: currentIndex) == .TEXT_FIELD{
                        HStack {
                            Image(systemName: "a.circle.fill")
                                .foregroundStyle(answer == "" ? Color.gray : Color.accent)
                            
                            TextField("Enter your answer.", text: $answer)
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
                                if avHelper.getAudioEngineRunning(){
                                    avHelper.endAudio()
                                }
                                
                                avHelper.resultText = ""
                                avHelper.startRecording()
                                isRecording = true
                            } else{
                                answer = avHelper.resultText
                                avHelper.endAudio()
                                isRecording = false
                            }
                        }){
                            VStack{
                                Image(systemName: isRecording ? "stop.circle.fill" : "waveform")
                                    .foregroundStyle(isRecording ? Color.white : Color.txt)
                                
                                Text(isRecording ? "Stop Recording" : "Start Recording")
                                    .foregroundStyle(isRecording ? Color.white : Color.txt)
                                
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: isRecording ? Color.red : Color.background, cornerRadius: 15))
                        
                        Spacer().frame(height: 10)
                        
                        Text(avHelper.resultText)
                            .foregroundStyle(Color.accent)
                        
                    } else if helper.getAnswerType(id: currentIndex) == .DRAW{
                        MMSECanvasView(canvas: $canvasView)
                            .frame(height: 250)
                    } else if helper.getAnswerType(id: currentIndex) == .PAPER{
                        if currentIndex == 22 || currentIndex == 23{
                            Rectangle()
                                .frame(width: 300, height: 300)
                                .foregroundStyle(
                                    LinearGradient(stops: [
                                        Gradient.Stop(color: .red, location: min(max((self.dragOffset.width + 300) / 300, 0), 1)),
                                        Gradient.Stop(color: .blue, location: min(max(self.dragOffset.width / 300, 0), 1))
                                    ], startPoint: .topTrailing, endPoint: .topLeading)
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged{ gesture in
                                            self.dragOffset = gesture.translation
                                            
                                            if currentIndex == 22{
                                                if min(max((self.dragOffset.width + 300) / 300, 0), 1) == 0.0{
                                                    isSuccess = true
                                                } else{
                                                    isSuccess = false
                                                }
                                            } else if currentIndex == 23{
                                                if min(max((self.dragOffset.width + 300) / 300, 0), 1) >= 0.4 && min(max((self.dragOffset.width + 300) / 300, 0), 1) >= 0.6{
                                                    isSuccess = true
                                                } else{
                                                    isSuccess = false
                                                }
                                            }
                                        }
                                )



                        }
                    }
                    
                    
                    if currentIndex == 26{
                        Spacer().frame(height: 20)
                        
                        ARViewContainer(isSuccess: $isSuccess)
                    }
                    
                    Spacer()
                    
                    if helper.getAnswerType(id: currentIndex) != .DRAW{
                        Button(action: {
                            if currentIndex < 27{
                                dragOffset = CGSize.zero
                                canvasView = PKCanvasView()
                                
                                if currentIndex < 22 || currentIndex == 27{
                                    helper.saveAnswer(answer: answer)
                                } else{
                                    helper.saveAnswer(answer: isSuccess ? "True" : "False")
                                }
                                
                                answer = ""
                                avHelper.resultText = ""
                                IsAnswerFieldFocused = false
                                isPlayed = false
                                isSuccess = false
                                currentIndex += 1
                            } else{
                                changeView = true
                            }
                        }){
                            HStack{
                                Spacer()
                                
                                Text(currentIndex < 27 ? "Next Question" : "Finish Test")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                                
                            }
                            
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
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
}

#Preview {
    MMSEInspectionView(helper: InspectionHelper())
        .environmentObject(UserManagement())
}
