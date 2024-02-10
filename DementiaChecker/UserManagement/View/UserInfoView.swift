//
//  UserInfoView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/9/24.
//

import SwiftUI

struct UserInfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var helper: UserManagement
    
    @State private var guardians: [UserInfoModel] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                VStack{
                    Image("ic_appstore")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .shadow(radius: 15)
                    
                    Text(helper.userInfo?.name ?? "알 수 없는 사용자")
                        .foregroundStyle(Color.txt)
                        .fontWeight(.semibold)
                    
                    Spacer().frame(height: 20)
                    
                    
                    HStack{
                        Text("보호자")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                        
                        Button(action: {}){
                            Image(systemName: "plus")
                        }
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Divider()
                    
                    Spacer().frame(height: 10)
                    
                    if guardians.isEmpty{
                        Text("등록된 보호자 없음")
                            .foregroundStyle(Color.gray)
                        
                    } else{
                        LazyVStack{
                            ForEach(guardians.indices, id: \.self){ index in
                                Button(action: {
                                    
                                }){
                                    InteritanceGuardianListModel(name: guardians[index].name, email: guardians[index].email)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                                
                            }
                        }
                    }
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Text("사용자 정보 변경")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Divider()
                    
                    Spacer().frame(height: 10)
                    
                    HStack{
                        Button(action: {}){
                            VStack{
                                Image(systemName: "key.fill")
                                    .foregroundStyle(Color.txt)
                                    .font(.title)
                                
                                Text("비밀번호")
                                    .foregroundStyle(Color.txt)
                            }.padding()
                                .frame(width: 120, height: 100)
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.btn, paddingValue: 0, cornerRadius: 15))
                        
                        Spacer().frame(width: 20)
                        
                        Button(action: {}){
                            VStack{
                                Image(systemName: "calendar")
                                    .foregroundStyle(Color.txt)
                                    .font(.title)
                                
                                Text("생년월일")
                                    .foregroundStyle(Color.txt)
                            }.padding()
                                .frame(width: 120, height: 100)
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.btn, paddingValue: 0, cornerRadius: 15))
                    }
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Button(action: {}){
                            VStack{
                                Image(systemName: "person.fill")
                                    .foregroundStyle(Color.txt)
                                    .font(.title)
                                
                                Text("이름")
                                    .foregroundStyle(Color.txt)
                            }.padding()
                                .frame(width: 120, height: 100)
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.btn, paddingValue: 0, cornerRadius: 15))
                        
                        Spacer().frame(width: 20)
                        
                        Button(action: {}){
                            VStack{
                                Image(systemName: "phone.fill")
                                    .foregroundStyle(Color.txt)
                                    .font(.title)
                                
                                Text("연락처")
                                    .foregroundStyle(Color.txt)
                            }.padding()
                                .frame(width: 120, height: 100)
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.btn, paddingValue: 0, cornerRadius: 15))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.crop.artframe")
                        .foregroundStyle(Color.gray)
                    
                    Spacer().frame(height: 10)

                    Text("유산 관리자를 추가하거나 제거하려면 더 보기 탭의 유산 관리자 페이지로 진입하십시오.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                    
                }.padding(20)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading,
                                    content: {
                            Button("닫기"){
                                self.dismiss()
                            }
                        })
                    }
                    .onAppear{
                        helper.getGuardians(){ result in
                            guard let result = result else{return}
                            
                            self.guardians = result
                        }
                    }
                    .navigationTitle(Text("프로필 정보"))
                    .animation(.easeInOut)

            }
        }
    }
}

#Preview {
    UserInfoView().environmentObject(UserManagement())
}
