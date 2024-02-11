//
//  DigitalInheritanceMainView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/29/24.
//

import SwiftUI

struct DigitalInheritanceMainView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var helper: UserManagement
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.bottom, .top])
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color.accent)
                        
                        VStack(alignment: .leading){
                            Text("유산 관리자 시작하기")
                                .fontWeight(.semibold)
                            
                            Text("신뢰하는 사람의 계정을 추가하면, 사용자가 사망한 이후 이 사람이 사용자의 데이터에 접근할 수 있게 됩니다.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Image(systemName: "lock.doc.fill")
                            .foregroundStyle(Color.accent)
                        
                        VStack(alignment: .leading){
                            Text("접근 제한")
                                .fontWeight(.semibold)
                            
                            Text("사용자가 사망했음이 확인되기 전까지 유산 관리자는 사용자가 공유를 허가한 정보 외의 어떠한 정보에도 접근할 수 없습니다.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Image(systemName: "doc.fill")
                            .foregroundStyle(Color.accent)
                        
                        VStack(alignment: .leading){
                            Text("디지털 유산 물려주기")
                                .fontWeight(.semibold)
                            
                            Text("애플리케이션 내에 저장된 검사 기록, 건강 상태 및 개인정보를 유산으로 사랑하는 사람과 공유하거나, 폐기를 요청할 수 있습니다.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: InheritanceGuardianSelectionView().environmentObject(helper)){
                        HStack{
                            Text("시작하기")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.txt)
                        }
                            .padding([.horizontal], 80)
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }.padding(20)
            }.navigationTitle(Text("유산 관리자"))
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

#Preview {
    DigitalInheritanceMainView()
        .environmentObject(UserManagement())
}
