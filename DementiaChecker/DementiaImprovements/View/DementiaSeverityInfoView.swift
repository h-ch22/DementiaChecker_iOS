//
//  DementiaSeverityInfoView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI

struct DementiaSeverityInfoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var severityList = [
        DementiaSeverityDataModel(icon: "0.circle.fill", title: "심각도 수준 0 (매우 경미)", description: "사물의 위치를 자주 잊어버립니다.\n사람 또는 사물의 이름을 쉽게 기억하지 못합니다.\n정밀 검사에서도 잘 드러나지 않는 수준의 심각도입니다.", IQLevel: "약 85"),
        DementiaSeverityDataModel(icon: "1.circle.fill", title: "심각도 수준 1 (경미)", description: "새로운 사람의 이름, 책의 내용, 단어를 떠올리지 못합니다.\n물건을 엉뚱한 곳에 두거나, 낯선 장소에서 길을 찾기 어려울 수 있으며, 업무 처리 능력이 떨어집니다.\n사용자는 자신의 기억력 저하를 쉽게 알아채지 못하며, 정밀 검사에서 낮은 확률로 발견될 수 있습니다.", IQLevel: "약 75"),
        DementiaSeverityDataModel(icon: "2.circle.fill", title: "심각도 수준 2 (중등도)", description: "남의 도움 없이 혼자 지내기 어려우며, 최근의 일이나 중요한 옛날 사건을 잘 잊어버립니다.\n계산 능력이 약간 떨어지며, 혼자 외출, 돈 계산이 어려워지며, 더 이상 제대로 된 일을 기억할 수 없습니다.\n사용자는 자신의 기억력 저하를 거의 알아채지 못하며, 무감동 증상이 드러납니다.\n정밀 검사에서 확정적으로 발견됩니다.", IQLevel: "약 65"),
        DementiaSeverityDataModel(icon: "3.circle.fill", title: "심각도 수준 3 (초기 중증)", description: "정신 연령이 역행하기 시작합니다.\n남의 도움 없이 혼자 지낼 수 없으며, 일상과 관련된 중요한 정보와 과거의 기억을 잊어버립니다.\n시간과 공간 구분 능력이 저하되며, 매우 간단한 계산조차 어려워집니다.\n사용자는 자신의 기억력 저하를 인지할 수 없습니다.", IQLevel: "약 50"),
        DementiaSeverityDataModel(icon: "4.circle.fill", title: "심각도 수준 4 (중기 중증)", description: "정신 연령이 심각하게 낮아집니다.\n가족의 이름을 기억하지 못하고, 최근의 일을 모두 잊어버립니다.\n과거의 기억을 간신히 기억할 수 있으며, 간단한 계산을 할 수 없습니다.\n매우 익숙한 장소 외에는 길을 찾을 수 없으며, 일상 생활을 다른 사람에게 의존해야합니다.\n사용자는 이 단계에서 낮과 밤을 구분하지 못하고, 심각한 불면증과 극심한 감정 기복 및 각종 성격 장애를 동반합니다.", IQLevel: "약 40"),
        DementiaSeverityDataModel(icon: "5.circle.fill", title: "심각도 수준 5 (말기 중증)", description: "정신 연령이 2~7세 수준으로 낮아집니다.\n의사소통 능력이 완전히 상실되며, 더 이상 혼자 외출할 수 없습니다.\n뇌에 저장된 모든 기억이 말소되며, 모든 행동을 타인에게 절대적으로 의존합니다.\n신체를 거의 움직일 수 없으며, 신체 기능이 급격히 저하됩니다.\n사용자는 이 단계부터 죽음에 가까워집니다.", IQLevel: "30 미만")
    ]
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                ScrollView{
                    VStack{
                        ForEach(severityList, id: \.self){ text in
                            DementiaSeverityInfoListModel(data: text)
                            
                            Spacer().frame(height: 20)
                        }
                    }.padding(20)
                }
                .navigationTitle(Text("치매 심각도 정보"))
                .toolbar{
                    ToolbarItem(placement: .topBarLeading, content: {Button("닫기"){
                        dismiss()
                    }})
                }
                .animation(.easeInOut)

            }
        }
    }
}

#Preview {
    DementiaSeverityInfoView()
}
