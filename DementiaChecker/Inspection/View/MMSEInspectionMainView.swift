//
//  MMSEInspectionMainView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import SwiftUI

struct MMSEInspectionMainView: View {
    @State private var introductionTexts = [
        IntroductionDataModel(icon: "magnifyingglass",
                              title: "Test Explanation",
                              description: "Through a simple written test that does not require tools or equipment, the app identifies specific functional impairments and areas of brain damage."),
        
        IntroductionDataModel(icon: "brain.filled.head.profile",
                              title: "Test Contents",
                              description: "The test assesses memory (language and visual), language function (fluency, language comprehension, naming, repetition), visuospatial abilities (copying, matching pictures, drawing a clock), frontal lobe function, attention/executive function, and emotional state."),
        
        IntroductionDataModel(icon: "iphone.gen3.radiowaves.left.and.right",
                              title: "Check Device Status",
                              description: "Before starting the test, check whether silent mode is off, the volume of the device, the status of the microphone, and whether smooth touch recognition is possible."),
        
        IntroductionDataModel(icon: "exclamationmark.triangle.fill",
                              title: "Precautions",
                              description: "Users can skip questions and should solve problems without the help of others for accurate diagnosis.\nThere are no benefits and/or disadvantages in test results based on test time.")
    ]
    
    @State private var changeView = false
    @State private var isRecording = false
    @State private var isPlaying = false
    @StateObject private var avHelper = AVHelper()
    @StateObject var helper: InspectionHelper
    
    @EnvironmentObject var userManagement: UserManagement
    
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
                            if avHelper.getAudioEngineRunning(){
                                avHelper.endAudio()
                            }
                            
                            avHelper.resultText = ""
                            avHelper.startRecording()
                            isRecording = true
                        } else{
                            avHelper.endAudio()
                            isRecording = false
                        }
                    }){
                        VStack{
                            Image(systemName: isRecording ? "stop.circle.fill" : "waveform")
                                .foregroundStyle(isRecording ? Color.white : Color.txt)
                            
                            Text(isRecording ? "Stop Recording" : "Microphone Test")
                                .foregroundStyle(isRecording ? Color.white : Color.txt)
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: isRecording ? Color.red : Color.background, paddingValue: 20, cornerRadius: 15))
                    
                    Spacer().frame(width: 20)
                    
                    Button(action: {
                        if !isPlaying{
                            isPlaying = true
                            avHelper.play(id: 0, isSample: true)
                        } else{
                            avHelper.stop()
                            isPlaying = false
                        }
                    }){
                        VStack{
                            Image(systemName: isPlaying ? "stop.circle.fill" : "play.fill")
                                .foregroundStyle(isPlaying ? Color.white : Color.txt)

                            Text(isPlaying ? "Stop" : "Speaker Test")
                                .foregroundStyle(isPlaying ? Color.white : Color.txt)

                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: isPlaying ? Color.red : Color.background, paddingValue: 20, cornerRadius: 15))
                }
                
                if avHelper.resultText != ""{
                    Spacer().frame(height: 10)
                    
                    Text("Recognized: \(avHelper.resultText)")
                        .foregroundStyle(Color.accent)
                }
                
                Spacer()
                
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(Color.accent)
                
                Text("When test preparation is complete, touch the button below to start the test.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    changeView = true
                }){
                    HStack{
                        Text("Start")
                            .foregroundStyle(Color.txt)
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.txt)
                    }.padding([.horizontal], 80)
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
            }.padding(20)
                .navigationTitle(Text("Start Cognitive Test"))
                .fullScreenCover(isPresented: $changeView, content: {
                    MMSEInspectionView(helper: helper)
                        .environmentObject(userManagement)
                    
                })
                .animation(.easeInOut)
        }
    }
}

#Preview {
    MMSEInspectionMainView(helper: InspectionHelper())
        .environmentObject(UserManagement())
}
