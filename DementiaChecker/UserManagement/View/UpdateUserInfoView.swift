//
//  UpdateUserInfoView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/14/24.
//

import SwiftUI

struct UpdateUserInfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var helper: UserManagement
    
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var birthday = Date.now
    @State private var name = ""
    @State private var phone = ""
    @State private var homeAddress = ""
    @State private var job = ""
    @State private var workAddress = ""
    @State private var tall = ""
    @State private var weight = ""
    @State private var isOutOfWork = false
    @State private var showProgress = false
    @State private var alertModel = false
    @State private var showAlert = false

    let updateType: UpdateUserInfoTypeModel
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                VStack{
                    switch updateType {
                    case .PASSWORD:
                        Image(systemName: "key.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Password")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .BIRTHDAY:
                        Image(systemName: "calendar")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Birthday")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .NAME:
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Name")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .PHONE:
                        Image(systemName: "phone.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Phone")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .HOME_ADDRESS:
                        Image(systemName: "house.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Home Address")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .WORK_ADDRESS:
                        Image(systemName: "building.2.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Work Address")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .TALL:
                        Image(systemName: "figure.stand")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Tall")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .WEIGHTS:
                        Image(systemName: "gauge")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("Change Weight")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                    }
                    
                    Spacer()
                    
                    switch updateType {
                    case .PASSWORD:
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundStyle(password == "" ? Color.gray : Color.accent)
                            
                            SecureField("Password", text: $password)
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
                            
                            SecureField("Confirm Password", text: $checkPassword)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                    case .BIRTHDAY:
                        DatePicker("Birthday", selection: $birthday, in: ...Date.now, displayedComponents: .date)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                        
                    case .NAME:
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundStyle(name == "" ? Color.gray : Color.accent)
                            
                            TextField("Name", text: $name)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                    case .PHONE:
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundStyle(phone == "" ? Color.gray : Color.accent)
                            
                            TextField("Phone", text: $phone)
                                .keyboardType(.phonePad)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                    case .HOME_ADDRESS:
                        HStack{
                            HStack {
                                Image(systemName: "house.fill")
                                    .foregroundStyle(homeAddress == "" ? Color.gray : Color.accent)
                                
                                TextField("Home Address", text: $homeAddress)
                                
                            }
                            .disabled(true)
                            .foregroundStyle(Color.accent)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            
                            NavigationLink(destination: AddressSearchView(address: $homeAddress).navigationTitle(Text("Address Search"))){
                                Image(systemName: "magnifyingglass")
                            }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 5))
                        }
                        
                    case .WORK_ADDRESS:
                        if !isOutOfWork{
                            HStack {
                                Image(systemName: "person.2.badge.gearshape.fill")
                                    .foregroundStyle(job == "" ? Color.gray : Color.accent)
                                
                                TextField("Job", text: $job)
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
                                    
                                    TextField("Work Address", text: $workAddress)
                                }
                                .disabled(true)
                                .foregroundStyle(Color.accent)
                                .padding(20)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 5)
                                
                                NavigationLink(destination: AddressSearchView(address: $workAddress).navigationTitle(Text("Address Search"))){
                                    Image(systemName: "magnifyingglass")
                                }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 5))
                            }
                        }
                        
                        Spacer().frame(height: 10)
                        
                        CheckBox(isChecked: $isOutOfWork, title: "Out of Work")

                        
                    case .TALL:
                        HStack {
                            Image(systemName: "figure.stand")
                                .foregroundStyle(tall == "" ? Color.gray : Color.accent)
                            
                            TextField("Tall (cm)", text: $tall)
                                .keyboardType(.numberPad)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        
                    case .WEIGHTS:
                        HStack {
                            Image(systemName: "gauge")
                                .foregroundStyle(weight == "" ? Color.gray : Color.accent)
                            
                            TextField("Weight (kg)", text: $weight)
                                .keyboardType(.numberPad)
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
                            switch updateType {
                            case .PASSWORD:
                                if password == checkPassword && password.count >= 6{
                                    showProgress = true

                                    helper.changePassword(password: password, completion: { result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                }
                                
                            case .BIRTHDAY:
                                showProgress = true
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy. MM. dd."
                                
                                helper.changeBirthday(birthday: dateFormatter.string(from: birthday), completion: { result in
                                    guard let result = result else{return}
                                    
                                    showProgress = false
                                    alertModel = result
                                    showAlert = true
                                })
                                
                            case .NAME:
                                if name != ""{
                                    showProgress = true

                                    helper.changeName(name: name, completion: { result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                }
                                
                            case .PHONE:
                                if phone != ""{
                                    showProgress = true

                                    helper.changePhone(phone: phone, completion: { result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                }
                                
                            case .HOME_ADDRESS:
                                if homeAddress != ""{
                                    showProgress = true

                                    helper.changeHomeAddress(address: homeAddress, completion: { result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                }
                                
                            case .WORK_ADDRESS:
                                if !isOutOfWork && workAddress != "" && job != ""{
                                    showProgress = true

                                    helper.changeWork(job: job, workAddress: workAddress, completion: {  result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                } else if isOutOfWork{
                                    showProgress = true

                                    helper.changeWork(job: "", workAddress: "", completion: {  result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                }
                                
                            case .TALL:
                                if tall != ""{
                                    showProgress = true

                                    helper.changeTall(tall: tall, completion: {  result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                }
                                
                            case .WEIGHTS:
                                if weight != ""{
                                    showProgress = true

                                    helper.changeWeight(weight: weight, completion: {  result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        alertModel = result
                                        showAlert = true
                                    })
                                }
                            }
                        }){
                            HStack{
                                Spacer()
                                
                                Text("Update Info")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                    }

                }.padding(20)
                    .navigationTitle(Text("Update User Info"))
                    .alert(isPresented: $showAlert, content: {
                        if alertModel{
                            return Alert(title: Text("Update Completed"), message: Text("User information has been updated."), dismissButton: .default(Text("OK")){
                                self.dismiss()
                            })
                        } else{
                            return Alert(title: Text("Error"), message: Text("There was an issue updating user information.\nPlease check your network connection and try again later."), dismissButton: .default(Text("OK")))
                        }
                    })
                    .animation(Animation.easeInOut(duration: 0.5), value: true)
            }
        }
    }
}

