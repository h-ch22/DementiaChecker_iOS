//
//  SignUpView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var name = ""
    @State private var phone = ""
    @State private var birthday = Date.now
    
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var alertType: UserManagementAlertType? = nil
    
    @StateObject private var helper = UserManagement()

    private func getEmptyFields() -> Bool{
        return (email == "" || password == "" || checkPassword == "" || name == "" || phone == "") ? true : false
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            ScrollView{
                VStack{
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
                        
                        Spacer().frame(height: 20)
                        
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
                        
                        Spacer().frame(height: 20)
                                                    
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundStyle(checkPassword == "" ? Color.gray : Color.accentColor)
                            
                            SecureField("비밀번호 확인", text: $checkPassword)
                        }
                        .foregroundStyle(Color.accentColor)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn).shadow(radius: 5)
                            .padding([.horizontal],15))
                        
                        Spacer().frame(height: 20)
                                                    
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundStyle(name == "" ? Color.gray : Color.accentColor)
                            
                            TextField("이름", text: $name)
                        }
                        .foregroundStyle(Color.accentColor)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn).shadow(radius: 5)
                            .padding([.horizontal],15))
                        
                        Spacer().frame(height: 20)
                                                    
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundStyle(phone == "" ? Color.gray : Color.accentColor)
                            
                            TextField("연락처", text: $phone)
                        }
                        .foregroundStyle(Color.accentColor)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn).shadow(radius: 5)
                            .padding([.horizontal],15))
                        
                        Spacer().frame(height: 20)
                        
                        DatePicker("생년월일", selection: $birthday, in: ...Date.now, displayedComponents: .date)
                        
                        Spacer().frame(height: 20)
                                                    
                        Button(action: {
                            if !getEmptyFields(){
                                showProgress = true
                                
                                if password.count < 6{
                                    showProgress = false
                                    alertType = .WEAK_PASSWORD
                                    showAlert = true
                                } else if password != checkPassword{
                                    showProgress = false
                                    alertType = .PASSWORD_MISMATCH
                                    showAlert = true
                                } else if !email.contains("@"){
                                    showProgress = false
                                    alertType = .INCORRECT_EMAIL_TYPE
                                    showAlert = true
                                }else{
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy. MM. dd."
                                    
                                    helper.signUp(email: email, password: password, name: name, phone: phone, birthday: dateFormatter.string(from: birthday)){ result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        
                                        if result == .SUCCESS{
                                            
                                        } else{
                                            alertType = result
                                            showAlert = true
                                        }
                                    }
                                }
                            }
                        }){
                            HStack{
                                Text("회원가입")
                                    .foregroundStyle(Color.white)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.white)
                            }.padding(20)
                                .padding([.horizontal], 80)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(
                                    getEmptyFields() ? Color.gray : Color.accentColor
                                ).shadow(radius: 5))
                        }
                        
                    }

                }.navigationTitle(Text("회원가입"))
                    .overlay(ProgressOverlay().isHidden(!showProgress))
                    .alert(isPresented: $showAlert, error: alertType){ _ in

                    } message: {error in
                        Text(error.recoverySuggestion ?? "")
                    }
                    .padding(20)
            }
        }
    }
}

#Preview {
    SignUpView()
}
