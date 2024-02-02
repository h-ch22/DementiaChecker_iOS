//
//  SignInView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var changeView = false
    @State private var alertType: UserManagementAlertType? = nil
    
    @StateObject private var helper = UserManagement()
    
    @AppStorage("authInfo") var authInfo = ""
    
    private func signIn(){
        if email != "" && password != ""{
            showProgress = true
            
            helper.signIn(email: email, password: password){ result in
                guard let result = result else{return}
                
                showProgress = false
                
                if result == .SUCCESS{
                    authInfo = "\(AES256Util.encrypt(string: email)), \(AES256Util.encrypt(string: password))"
                    changeView = true
                } else{
                    alertType = result
                    showAlert = true
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])

                VStack{
                    Spacer()
                    
                    TextWithImageLogo_Vertical()
                    
                    Spacer()
                    
                    Group{
                        HStack {
                            Image(systemName: "at.circle.fill")
                                .foregroundStyle(email == "" ? Color.gray : Color.accent)
                            
                            TextField("E-Mail", text: $email)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundStyle(password == "" ? Color.gray : Color.accent)
                            
                            SecureField("비밀번호", text: $password)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        signIn()
                    }){
                        HStack{
                            Text("로그인")
                                .foregroundStyle(Color.white)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                        }.padding(20)
                            .padding([.horizontal], 80)
                            .background(
                                LinearGradient(colors: email != "" && password != "" ? [Color.accent.opacity(0.4), Color.accent.opacity(0.3)] : [Color.gray.opacity(0.4), Color.gray.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    HStack{
                        NavigationLink(destination: EmptyView()){
                            Text("비밀번호 재설정")
                                .foregroundStyle(Color.white)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SignUpView()){
                            Text("회원가입")
                                .foregroundStyle(Color.white)
                        }
                    }
                    
                    Spacer()
                    
                    Text("© 2024 Changjin Ha\nAll Rights Reserved.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.gray)
                }.padding(20)
                    .navigationTitle(Text("로그인"))
                    .toolbar(.hidden)
                    .overlay(ProgressOverlay().isHidden(!showProgress))
                    .alert(isPresented: $showAlert, error: alertType){ _ in

                    } message: {error in
                        Text(error.recoverySuggestion ?? "")
                    }
            }.fullScreenCover(isPresented: $changeView, content: {
                MainView()
                    .environmentObject(helper)
            })
            .onAppear{
                if authInfo.contains(", "){
                    let authInfoSplited = authInfo.split(separator: ", ")
                    
                    email = AES256Util.decrypt(encoded: String(authInfoSplited[0]))
                    password = AES256Util.decrypt(encoded: String(authInfoSplited[1]))
                    
                    signIn()
                }
            }
        }
        
    }
}

#Preview {
    SignInView()
}
