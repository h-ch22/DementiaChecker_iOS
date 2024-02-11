//
//  DementiaImprovementMainView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI

struct DementiaImprovementMainView: View {
    @State private var showHelper = false
    @State private var introductionTexts = [
        IntroductionDataModel(icon: "brain.head.profile.fill",
                                        title: "치매 개선 프로세스 시작",
                                        description: "명상, 인지 능력 향상 프로세스 등을 통해 치매의 진행 속도를 늦추거나, 일부 증상을 호전시킵니다."),
        
        IntroductionDataModel(icon: "puzzlepiece.extension.fill",
                                        title: "프로세스 정보",
                                        description: "이 프로세스는 사용자의 심각도에 따라 최대 1시간 이상이 소요될 수 있습니다.\n인지 능력 향상을 위해 다수의 문제를 해결해야하며, 치매 심각도 개선 정도에 따라 난이도를 조절하십시오."),
        
        IntroductionDataModel(icon: "lightbulb.max.fill",
                                        title: "의학적 자문 얻기",
                                        description: "치매의 심각도에 따라 이 프로세스를 통해 치료상의 이익을 얻을 수 없을 수 있습니다.\n의료기관에 방문해 이 프로세스의 적합도를 확인한 후 진행하는 것을 권장합니다.")
    ]
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Spacer()
                
                Group{
                    ForEach(introductionTexts, id: \.self){ text in
                        InspectionIntroductionListModel(icon: text.icon, title: text.title, description: text.description)
                        
                        Spacer().frame(height: 20)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.badge.shield.checkmark.fill")
                        .foregroundStyle(Color.accent)
                    
                    Text("이 프로세스는 치매의 완전한 호전을 보증하지 않습니다.\n치매의 정도가 심각한 경우 의료기관에 방문해 전문가와 상담을 통해 의학적 조치를 받으십시오.\n사용자는 Dementia Checker를 통해 치료상의 이익을 얻을 수 없습니다.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Spacer()
                        
                        NavigationLink(destination: DementiaImprovementTypeSelectionView()){
                            HStack{
                                Spacer()
                                
                                Text("다음 단계로")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                                
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                        
                        Spacer().frame(width: 20)
                        
                        Button(action: {
                            showHelper = true
                        }){
                            Image(systemName: "questionmark")
                                .font(.caption)
                                .foregroundStyle(Color.txt)
                        }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
                    }
                }
            }.padding(20).navigationTitle(Text("치매 개선 프로세스 시작"))
                .sheet(isPresented: $showHelper, content: {
                    DementiaSeverityInfoView()
                })
                .animation(.easeInOut)
        }
    }
}

#Preview {
    DementiaImprovementMainView()
}
