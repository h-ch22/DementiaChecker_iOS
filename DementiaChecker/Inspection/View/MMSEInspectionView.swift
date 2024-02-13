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
    @State private var changeView = false
    @State private var isSuccess = false
    
    @State private var x: CGFloat = 50
    @State private var y: CGFloat = 400
    
    @State private var currentInspectingType = InspectionTypeModel.MMSE
    @State private var errorType : InspectionTypeModel? = nil
    @State private var isDone = false
    
    @FocusState private var IsAnswerFieldFocused: Bool
    
    @StateObject private var helper = InspectionHelper()
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
                        Text(errorType == nil ? "검사 진행 중" : "검사 실패")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text(errorType == nil ? "Dementia Checker에서 사용자의 인지 기능, 라이프스타일 데이터를 기반으로 치매 여부를 진단하고 있습니다.\n잠시 기다려 주십시오." : "Dementia Checker에서 사용자의 데이터를 기반으로 치매 여부를 진단하는 중 문제가 발셍했습니다.\n나중에 다시 시도하거나, 데이터를 확인하십시오.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.gray)
                    } else{
                        Text("검사 완료")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Dementia Checker에서 사용자의 데이터로부터 치매 여부 진단을 완료하였습니다.\n검사 결과 확인 버튼을 눌러 검사 결과를 확인하십시오.")
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
                                
                            case .SLEEP, .WALK:
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                        } else if errorType == .MMSE{
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.orange)
                        }
                        
                        Spacer().frame(width: 10)
                        
                        Text("인지 기능 검사")
                            .foregroundStyle(currentInspectingType == .MMSE ? Color.txt : Color.gray)
                            .fontWeight(currentInspectingType == .MMSE ? .semibold : .regular)
                            .font(currentInspectingType == .MMSE ? .headline : .caption)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack{
                        if errorType != .SLEEP{
                            switch currentInspectingType {
                            case .MMSE:
                                EmptyView()
                                
                            case .SLEEP:
                                ProgressView()

                            case .WALK:
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                        } else if errorType == .SLEEP{
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.orange)
                        }

                        
                        Spacer().frame(width: 10)

                        Text("수면 검사")
                            .foregroundStyle(currentInspectingType == .SLEEP ? Color.txt : Color.gray)
                            .fontWeight(currentInspectingType == .SLEEP ? .semibold : .regular)
                            .font(currentInspectingType == .SLEEP ? .headline : .caption)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    HStack{
                        if isDone{
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.green)
                        } else if errorType != .WALK{
                            switch currentInspectingType {
                            case .MMSE, .SLEEP:
                                EmptyView()
                                
                            case .WALK:
                                ProgressView()
                            }
                        } else if errorType == .WALK{
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(Color.orange)
                        }

                        Spacer().frame(width: 10)
                        
                        if !isDone{
                            Text("라이프로그 데이터 검사")
                                .foregroundStyle(currentInspectingType == .WALK ? Color.txt : Color.gray)
                                .fontWeight(currentInspectingType == .WALK ? .semibold : .regular)
                                .font(currentInspectingType == .WALK ? .headline : .caption)
                        } else{
                            Text("라이프로그 데이터 검사")
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

                                Text("이전 화면으로")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()

                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                    } else if isDone{
                        Button(action: {}){
                            HStack{
                                Spacer()

                                Text("검사 결과 확인")
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
                    DispatchQueue.global().async{
                        helper.grading(job: userManagement.userInfo?.job ?? "",
                                                    homeLatLng: userManagement.userInfo?.homeAddress ?? "",
                                       workLatLng: userManagement.userInfo?.workAddress ?? ""){ MMSEResult in
                            guard let MMSEResult = MMSEResult else{return}
                            
                            if MMSEResult{
                                currentInspectingType = .SLEEP
                            } else{
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
                        Text("2초 이상 눈을 감으세요.")
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
                                    .foregroundStyle(isRecording ? Color.white : Color.txt)
                                
                                Text(isRecording ? "녹음 중지" : "녹음 시작")
                                    .foregroundStyle(isRecording ? Color.white : Color.txt)
                                
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: isRecording ? Color.red : Color.background, cornerRadius: 15))
                        
                        Spacer().frame(height: 10)
                        
                        Text(helper.resultText)
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
                                            print("start: \(min(max((self.dragOffset.width + 300) / 300, 0), 1)), end: \(min(max(self.dragOffset.width / 300, 0), 1))")
                                            
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
                                helper.resultText = ""
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
                                
                                Text(currentIndex < 27 ? "다음 문항" : "검사 종료")
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
    MMSEInspectionView()
        .environmentObject(UserManagement())
}
