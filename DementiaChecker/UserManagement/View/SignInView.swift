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
                                .foregroundStyle(email == "" ? Color.gray : Color.accentColor)
                            
                            TextField("E-Mail", text: $email)
                        }
                        .foregroundStyle(Color.accentColor)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn).shadow(radius: 5)
                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundStyle(password == "" ? Color.gray : Color.accentColor)
                            
                            SecureField("비밀번호", text: $password)
                        }
                        .foregroundStyle(Color.accentColor)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn).shadow(radius: 5)
                            .padding([.horizontal],15))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if email != "" && password != ""{
                            showProgress = true
                            
                            helper.signIn(email: email, password: password){ result in
                                guard let result = result else{return}
                                
                                showProgress = false
                                
                                if result == .SUCCESS{
                                    
                                } else{
                                    alertType = result
                                    showAlert = true
                                }
                            }
                        }
                    }){
                        HStack{
                            Text("로그인")
                                .foregroundStyle(Color.white)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                        }.padding(20)
                            .padding([.horizontal], 80)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(
                                (email == "" || password == "") ? Color.gray : Color.accentColor
                            ).shadow(radius: 5))
                    }
                    
                    Spacer()
                    
                    HStack{
                        NavigationLink(destination: EmptyView()){
                            Text("비밀번호 재설정")
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SignUpView()){
                            Text("회원가입")
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
            }
        }
        
    }
}

#Preview {
    SignInView()
}
