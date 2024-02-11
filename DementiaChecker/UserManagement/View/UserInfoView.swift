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
    @State private var showProgress = false
    @State private var alertType: UserManagementAlertType? = nil
    @State private var showAlert = false
    @State private var showSignInView = false
    
    @AppStorage("authInfo") var authInfo = ""

    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                ScrollView{
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
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                            
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
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
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
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                            
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
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "person.crop.artframe")
                            .foregroundStyle(Color.gray)
                        
                        Spacer().frame(height: 10)
                        
                        Text("유산 관리자를 추가하거나 제거하려면 더 보기 탭의 유산 관리자 페이지로 진입하십시오.")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer().frame(height: 20)
                        
                        if showProgress{
                            DotProgressView()
                        } else{
                            HStack {
                                Button(action : {
                                    showProgress = true
                                    
                                    helper.signOut(){ result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        
                                        if result{
                                            if authInfo.contains(", "){
                                                authInfo = ""
                                            }
                                            
                                            showSignInView = true
                                        } else{
                                            alertType = .SIGN_OUT_FAIL
                                            showAlert = true
                                        }
                                    }
                                }){
                                    Text("로그아웃")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .underline(true, color : .gray)
                                }
                                
                                Text("또는")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Button(action : {
                                    showProgress = true
                                    
                                    helper.cancelMembership(){ result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        
                                        if result{
                                            if authInfo.contains(", "){
                                                authInfo = ""
                                            }
                                            
                                            showSignInView = true
                                        } else{
                                            alertType = .DELETE_MEMBERSHIP_FAIL
                                            showAlert = true
                                        }
                                    }
                                }){
                                    Text("회원 탈퇴")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .underline(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: .gray)
                                }
                            }
                        }
                    }
                }.padding(20)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading,
                                    content: {
                            Button("닫기"){
                                self.dismiss()
                            }
                        })
                    }
                    .alert(isPresented: $showAlert, error: alertType){ _ in

                    } message: {error in
                        Text(error.recoverySuggestion ?? "")
                    }
                    .onAppear{
                        helper.getGuardians(){ result in
                            guard let result = result else{return}
                            
                            self.guardians = result
                        }
                    }
                    .navigationTitle(Text("프로필 정보"))
                    .animation(.easeInOut)
                    .fullScreenCover(isPresented: $showSignInView, content: {
                        SignInView()
                    })
                
            }
        }
        
    }
}

#Preview {
    UserInfoView().environmentObject(UserManagement())
}
