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
    @State private var job = ""
    @State private var workAddress = ""
    @State private var homeAddress = ""
    @State private var isOutOfWork = false
    @State private var tall = ""
    @State private var weight = ""
    @State private var selectedGender = "남성"
    @State private var genders = ["남성", "여성"]
    
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var changeView = false
    @State private var alertType: UserManagementAlertType? = nil
    
    @StateObject private var helper = UserManagement()
    @AppStorage("authInfo") var authInfo = ""
    
    let userType: UserTypeModel
    
    private func getEmptyFields() -> Bool{
        if userType == .PATIENT{
            return (email == "" || password == "" || checkPassword == "" || name == "" || phone == "" || homeAddress == "" || tall == "" || weight == "" || (!isOutOfWork && (workAddress == "" || job == ""))) ? true : false
        } else{
            return (email == "" || password == "" || checkPassword == "" || name == "" || phone == "" || patientEmail == "" || tall == "" || weight == "" || (!isOutOfWork && (workAddress == "" || job == ""))) ? true : false
        }
        
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
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            HStack {
                                Image(systemName: "house.fill")
                                    .foregroundStyle(homeAddress == "" ? Color.gray : Color.accent)
                                
                                TextField("집 주소", text: $homeAddress)
                                
                            }
                            .disabled(true)
                            .foregroundStyle(Color.accent)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            
                            NavigationLink(destination: AddressSearchView(address: $homeAddress).navigationTitle(Text("주소 검색"))){
                                Image(systemName: "magnifyingglass")
                            }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 5))
                        }
                        
                        Spacer().frame(height: 20)
                        
                        if !isOutOfWork{
                            HStack {
                                Image(systemName: "person.2.badge.gearshape.fill")
                                    .foregroundStyle(job == "" ? Color.gray : Color.accent)
                                
                                TextField("직업", text: $job)
                            }
                            .foregroundStyle(Color.accent)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            
                            Spacer().frame(height: 20)
                            
                            HStack{
                                HStack {
                                    Image(systemName: "building.2.fill")
                                        .foregroundStyle(workAddress == "" ? Color.gray : Color.accent)
                                    
                                    TextField("직장 주소", text: $workAddress)
                                }
                                .disabled(true)
                                .foregroundStyle(Color.accent)
                                .padding(20)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 5)
                                
                                NavigationLink(destination: AddressSearchView(address: $workAddress).navigationTitle(Text("주소 검색"))){
                                    Image(systemName: "magnifyingglass")
                                }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 5))
                            }
                        }
                        
                        Spacer().frame(height: 10)
                        
                        CheckBox(isChecked: $isOutOfWork, title: "무직")
                        
                        Spacer().frame(height: 20)
                        
                        HStack {
                            Image(systemName: "figure.stand")
                                .foregroundStyle(tall == "" ? Color.gray : Color.accent)
                            
                            TextField("키 (cm)", text: $tall)
                                .keyboardType(.numberPad)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                        Spacer().frame(height: 20)
                        
                        HStack {
                            Image(systemName: "gauge")
                                .foregroundStyle(weight == "" ? Color.gray : Color.accent)
                            
                            TextField("몸무게 (kg)", text: $weight)
                                .keyboardType(.numberPad)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                        Spacer().frame(height: 20)
                        
                        Picker("성별", selection: $selectedGender){
                            ForEach(genders, id: \.self){
                                Text($0)
                                    .foregroundStyle(Color.txt)
                            }
                        }.pickerStyle(MenuPickerStyle())
                            .padding()
                        
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
                        
                        if showProgress{
                            DotProgressView()
                        } else{
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
                                                    helper.signUp(email: email, password: password, name: name, phone: phone, birthday: dateFormatter.string(from: birthday), patientEmail: patientEmail, homeAddress: homeAddress, job: isOutOfWork ? "" : job, workAddress: isOutOfWork ? "" : workAddress, tall: tall, weight: weight, userType: self.userType == .GUARDIAN ? "GUARDIAN" : "PATIENT", gender: selectedGender == "남성" ? "Male" : "Female"){ result in
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
                                            helper.signUp(email: email, password: password, name: name, phone: phone, birthday: dateFormatter.string(from: birthday), patientEmail: patientEmail, homeAddress: homeAddress, job: isOutOfWork ? "" : job, workAddress: isOutOfWork ? "" : workAddress, tall: tall, weight: weight, userType: self.userType == .GUARDIAN ? "GUARDIAN" : "PATIENT", gender: selectedGender == "남성" ? "Male" : "Female"){ result in
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
                                }
                            }){
                                HStack{
                                    Spacer()
                                    
                                    Text("회원가입")
                                        .foregroundStyle(Color.txt)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                }
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                        }
                        
                        
                    }
                    
                }.navigationTitle(Text("회원가입"))
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
