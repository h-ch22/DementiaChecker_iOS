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
    
    private func isEmpty() -> Bool {
        return email == "" || password == ""
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])

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
                        .background(.ultraThinMaterial)
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
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    if showProgress{
                        DotProgressView()
                    } else{
                        Button(action: {
                            signIn()
                        }){
                            HStack{
                                Spacer()

                                Text("로그인")
                                    .foregroundStyle(isEmpty() ? Color.white : Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(isEmpty() ? Color.white : Color.txt)
                                
                                Spacer()
                            }
                                
                        }.buttonStyle(NewMorphButtonStyle(foreground: isEmpty() ? Color.gray : Color.background))
                    }
                    
                    Spacer()
                    
                    HStack{
                        NavigationLink(destination: EmptyView()){
                            Text("비밀번호 재설정")
                                .foregroundStyle(Color.txt)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: UserTypeSelectionView()){
                            Text("회원가입")
                                .foregroundStyle(Color.txt)
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
            .animation(.easeInOut)
        }
        
    }
}

#Preview {
    SignInView()
}
