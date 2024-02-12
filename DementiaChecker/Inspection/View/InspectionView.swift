//
//  InspectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct InspectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var introductionTexts = [
        IntroductionDataModel(icon: "magnifyingglass",
                                        title: "딥러닝을 이용한 치매 검사",
                                        description: "생활 패턴, 기본 검사 결과를 바탕으로 딥러닝을 이용해 사용자의 치매 상황을 확인하고 예측할 수 있습니다."),
        
        IntroductionDataModel(icon: "calendar.badge.clock",
                                        title: "검사 기록 확인",
                                        description: "검사 기록 탭에서 사용자의 검사 기록을 일자별로 확인하고, 심각도 변화 추이를 확인할 수 있습니다."),
        
        IntroductionDataModel(icon: "applewatch",
                                        title: "정확한 진단을 위해 Apple Watch 착용하기",
                                        description: "정확한 진단을 위해 Apple Watch를 착용하고 최소 2주 이상 생활하십시오.")
    ]
    
    @EnvironmentObject var userManagement: UserManagement
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                VStack{
                    Spacer()

                    ForEach(introductionTexts, id: \.self){ text in
                        InspectionIntroductionListModel(icon: text.icon, title: text.title, description: text.description)
                        
                        Spacer().frame(height: 20)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.badge.shield.checkmark.fill")
                        .foregroundStyle(Color.accent)
                    
                    Text("Dementia Checker는 진단 결과의 정확성을 보증하지 않습니다.\n치매가 의심되는 경우 의료기관에 방문해 전문가와 상담을 통해 의학적 조치를 받으십시오.\n사용자는 Dementia Checker를 통해 치료상의 이익을 얻을 수 없습니다.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: MMSEInspectionMainView().environmentObject(userManagement)){
                        HStack{
                            Spacer()

                            Text("다음 단계로")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.txt)
                            
                            Spacer()

                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }.padding(20)
                .navigationTitle(Text("검사 시작하기"))
                .toolbar{
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button("닫기"){
                            dismiss()
                        }
                    })
                }
                .animation(.easeInOut)

            }
        }
    }
}

#Preview {
    InspectionView()
        .environmentObject(UserManagement())
}
