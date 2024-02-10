//
//  MMSEInspectionMainView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct MMSEInspectionMainView: View {
    @State private var introductionTexts = [
        IntroductionDataModel(icon: "magnifyingglass",
                                        title: "검사 설명",
                                        description: "도구나 설비가 필요하지 않은 지필식 검사를 통해 사용자의 특정 기능 장애와 뇌 영역 중 손상 영역을 확인합니다."),
        
        IntroductionDataModel(icon: "brain.filled.head.profile",
                                        title: "검사 내용",
                                        description: "기억력 (언어 및 시각), 언어 기능 (유창성, 언어 이해력, 이름 말하기, 따라 말하기), 시공간능력(따라 그리기, 그림 맞추기, 시계 그리기), 전두엽 기능, 주의집중력 실행증, 정서 상태를 검사합니다."),
        
        IntroductionDataModel(icon: "iphone.gen3.radiowaves.left.and.right",
                                        title: "기기 상태 점검하기",
                                        description: "검사를 시작하기 전에 무음모드 해제 여부, 기기의 볼륨, 마이크 상태 및 원활한 터치 인식이 가능한 상태인지 확인해주십시오."),
        
        IntroductionDataModel(icon: "exclamationmark.triangle.fill",
                                        title: "주의사항",
                                        description: "사용자는 문제를 건너뛸 수 있으며, 정확한 진단을 위해 다른 사람의 도움 없이 스스로 문제를 해결하십시오.\n검사 시간에 따른 검사 결과 상의 이익 및/또는 불이익은 없습니다.")
    ]
    
    @State private var changeView = false
    @State private var isRecording = false
    @StateObject private var helper = InspectionHelper()
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Spacer()
                
                ForEach(introductionTexts, id: \.self){ text in
                    InspectionIntroductionListModel(icon: text.icon, title: text.title, description: text.description)
                    
                    Spacer().frame(height: 20)
                }
                
                Spacer()
                
                HStack{
                    Button(action: {
                        if !isRecording{
                            if helper.getAudioEngineRunning(){
                                helper.endAudio()
                            }
                            
                            helper.resultText = ""
                            helper.startRecording()
                            isRecording = true
                        } else{
                            helper.endAudio()
                            isRecording = false
                        }
                    }){
                        VStack{
                            Image(systemName: isRecording ? "stop.circle.fill" : "waveform")
                            Text(isRecording ? "녹음 중지" : "마이크 테스트")
                        }.padding(20)
                            .background(
                                .ultraThinMaterial
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                    
                    Spacer().frame(width: 20)
                    
                    Button(action: {
                        helper.play(id: 0, isSample: true)
                    }){
                        VStack{
                            Image(systemName: "play.fill")
                            Text("스피커 테스트")
                        }.padding(20)
                            .background(
                                .ultraThinMaterial
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                }
                
                if helper.resultText != ""{
                    Spacer().frame(height: 10)
                    
                    Text("인식됨: \(helper.resultText)")
                        .foregroundStyle(Color.accent)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(Color.accent)
                
                Text("검사 준비가 완료된 경우 아래 버튼을 터치해 검사를 시작하십시오.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    changeView = true
                }){
                    HStack{
                        Text("시작하기")
                            .foregroundStyle(Color.white)
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.white)
                    }.padding([.horizontal], 80)
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.accentColor))
            }.padding(20)
                .navigationTitle(Text("인지기능 검사 시작하기"))
                .fullScreenCover(isPresented: $changeView, content: {
                    MMSEInspectionView()
                })
                .animation(.easeInOut)
        }
    }
}

#Preview {
    MMSEInspectionMainView()
}
