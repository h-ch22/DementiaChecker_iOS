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
    @State private var patientEmail = ""
    
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var changeView = false
    @State private var alertType: UserManagementAlertType? = nil
    
    @StateObject private var helper = UserManagement()
    
    let userType: UserTypeModel

    private func getEmptyFields() -> Bool{
        if userType == .PATIENT{
            return (email == "" || password == "" || checkPassword == "" || name == "" || phone == "") ? true : false
        } else{
            return (email == "" || password == "" || checkPassword == "" || name == "" || phone == "" || patientEmail == "") ? true : false
        }
        
    }
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])
            
            ScrollView{
                VStack{
                    Spacer()
                    
                    Group{
                        HStack {
                            Image(systemName: "at.circle.fill")
                                .foregroundStyle(email == "" ? Color.gray : Color.accent)
                            
                            TextField("E-Mail", text: $email)
                                .keyboardType(.emailAddress)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                        Spacer().frame(height: 20)
                        
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
                        
                        Spacer().frame(height: 20)
                                                    
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundStyle(checkPassword == "" ? Color.gray : Color.accent)
                            
                            SecureField("비밀번호 확인", text: $checkPassword)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                        Spacer().frame(height: 20)
                                                    
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundStyle(name == "" ? Color.gray : Color.accent)
                            
                            TextField("이름", text: $name)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                        Spacer().frame(height: 20)
                                                    
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundStyle(phone == "" ? Color.gray : Color.accent)
                            
                            TextField("연락처", text: $phone)
                                .keyboardType(.phonePad)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                                      
                        if userType == .GUARDIAN{
                            Spacer().frame(height: 20)
                                                        
                            HStack {
                                Image(systemName: "figure.arms.open")
                                    .foregroundStyle(patientEmail == "" ? Color.gray : Color.accent)
                                
                                TextField("환자 E-Mail", text: $patientEmail)
                                    .keyboardType(.emailAddress)
                            }
                            .foregroundStyle(Color.accent)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                        }

                        
                        Spacer().frame(height: 20)
                        
                        DatePicker("생년월일", selection: $birthday, in: ...Date.now, displayedComponents: .date)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                        
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
                                    
                                    if userType == .GUARDIAN{
                                        helper.searchPatient(email: patientEmail){ result in
                                            guard let result = result else{return}
                                            
                                            if result{
                                                helper.signUp(email: email, password: password, name: name, phone: phone, birthday: dateFormatter.string(from: birthday), patientEmail: patientEmail, userType: self.userType == .GUARDIAN ? "GUARDIAN" : "PATIENT"){ result in
                                                    guard let result = result else{return}
                                                    
                                                    showProgress = false
                                                    
                                                    if result == .SUCCESS{
                                                        changeView = true
                                                    } else{
                                                        alertType = result
                                                        showAlert = true
                                                    }
                                                }
                                            } else{
                                                showProgress = false
                                                alertType = .PATIENT_EMAIL_DOES_NOT_FOUND
                                                showAlert = true
                                            }
                                        }
                                    } else{
                                        helper.signUp(email: email, password: password, name: name, phone: phone, birthday: dateFormatter.string(from: birthday), patientEmail: patientEmail, userType: self.userType == .GUARDIAN ? "GUARDIAN" : "PATIENT"){ result in
                                            guard let result = result else{return}
                                            
                                            showProgress = false
                                            
                                            if result == .SUCCESS{
                                                changeView = true
                                            } else{
                                                alertType = result
                                                showAlert = true
                                            }
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
                            }.padding([.horizontal], 80)
                        }.buttonStyle(NewMorphButtonStyle(foreground: getEmptyFields() ? Color.gray : Color.accentColor))
                        
                    }

                }.navigationTitle(Text("회원가입"))
                    .overlay(ProgressOverlay().isHidden(!showProgress))
                    .alert(isPresented: $showAlert, error: alertType){ _ in

                    } message: {error in
                        Text(error.recoverySuggestion ?? "")
                    }
                    .padding(20)
                    .animation(.easeInOut)
            }.fullScreenCover(isPresented: $changeView, content: {
                MainView()
                    .environmentObject(helper)
            })
            
        }
    }
}

#Preview {
    SignUpView(userType: UserTypeModel.PATIENT)
}
