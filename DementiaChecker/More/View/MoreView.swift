//
//  MoreView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var helper: UserManagement
    
    @State private var showDigialInheritance = false
    @State private var showUserInfo = false

    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                HStack{
                    TextLogoRegular()
                    
                    Spacer()
                }
                
                Button(action: {
                    showUserInfo = true
                }){
                    HStack{
                        Image("ic_appstore")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .shadow(radius: 5)
                        
                        Text(helper.userInfo?.name ?? "알 수 없는 사용자")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }.padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 1)

                }
                
                Divider()
                
                NavigationLink(destination: EmptyView()){
                    HStack{
                        Image(systemName: "lightbulb.max.fill")
                            .foregroundStyle(Color.txt)

                        Text("치매 예방과 관련된 내용")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }.padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 1)
                }
                
                NavigationLink(destination: EmptyView()){
                    HStack{
                        Image(systemName: "brain.filled.head.profile")
                            .foregroundStyle(Color.txt)

                        Text("심각도별 치매 개선 프로세스")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }.padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 1)
                }
                
                Button(action: { showDigialInheritance = true }){
                    HStack{
                        Image(systemName: "person.crop.artframe")
                            .foregroundStyle(Color.txt)

                        Text("유산 관리자")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }.padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 1)
                }
                
                NavigationLink(destination: EmptyView()){
                    HStack{
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(Color.txt)

                        Text("정보")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }.padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 1)
                }
                
                Spacer()
                
            }.padding(20)
                .sheet(isPresented: $showDigialInheritance, content: {
                    DigitalInheritanceMainView()
                        .environmentObject(helper)
                })
                .sheet(isPresented: $showUserInfo, content: {
                    UserInfoView()
                        .environmentObject(helper)
                })
        }
    }
}

#Preview {
    MoreView()
        .environmentObject(UserManagement())
}
