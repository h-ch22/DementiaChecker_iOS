//
//  InheritanceGuardianSelectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/2/24.
//

import SwiftUI

struct InheritanceGuardianSelectionView: View {
    @EnvironmentObject var helper: UserManagement

    @State private var showProgress = true
    @State private var email = ""
    @State private var guardians: [UserInfoModel] = []
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Text("유산 관리자의 E-Mail을 선택하거나, 기존의 보호자를 유산 관리자로 지정할 수 있습니다.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 20)
                
                HStack{
                    Text("보호자 선택")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                    
                    if showProgress{
                        ProgressView()
                    }
                }
                
                Spacer().frame(height: 20)
                
                LazyVStack{
                    ForEach(guardians.indices, id: \.self){ index in
                        NavigationLink(destination: EmptyView()){
                            InteritanceGuardianListModel(name: guardians[index].name, email: guardians[index].email)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }

                    }
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "at.circle.fill")
                        .foregroundStyle(email == "" ? Color.gray : Color.accent)
                    
                    TextField("E-Mail", text: $email)
                }
                .foregroundStyle(Color.accent)
                .padding(20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 5)
                
                Spacer()
                
                if email != ""{
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            Text("다음 단계로")
                            
                            Image(systemName: "chevron.right")
                        }.padding(20)
                            .padding([.horizontal], 80)
                            .background(
                                .ultraThickMaterial
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                }
                
            }.padding(20)
            .navigationTitle(Text("유산 관리자 선택하기"))
            .onAppear{
                helper.getGuardians(){ result in
                    guard let result = result else{return}
                    
                    self.guardians = result
                    showProgress = false
                }
            }
        }
    }
}

#Preview {
    InheritanceGuardianSelectionView()
}
