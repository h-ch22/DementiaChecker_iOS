//
//  UpdateUserInfoView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/14/24.
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
                        
                        Text("비밀번호 변경")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .BIRTHDAY:
                        Image(systemName: "calendar")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("생년월일 변경")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .NAME:
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("이름 변경")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .PHONE:
                        Image(systemName: "phone.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("연락처 변경")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .HOME_ADDRESS:
                        Image(systemName: "house.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("집 주소 변경")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .WORK_ADDRESS:
                        Image(systemName: "building.2.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("회사 주소 변경")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .TALL:
                        Image(systemName: "figure.stand")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("키 변경")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                    case .WEIGHTS:
                        Image(systemName: "gauge")
                            .font(.largeTitle)
                            .foregroundStyle(Color.txt)
                        
                        Spacer().frame(height: 10)
                        
                        Text("몸무게 변경")
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
                        
                    case .BIRTHDAY:
                        DatePicker("생년월일", selection: $birthday, in: ...Date.now, displayedComponents: .date)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                        
                    case .NAME:
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
                        
                    case .PHONE:
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
                        
                    case .HOME_ADDRESS:
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
                        
                    case .WORK_ADDRESS:
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

                        
                    case .TALL:
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
                        
                    case .WEIGHTS:
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
                                
                                Text("정보 변경")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                    }

                }.padding(20)
                    .navigationTitle(Text("사용자 정보 변경"))
                    .alert(isPresented: $showAlert, content: {
                        if alertModel{
                            return Alert(title: Text("업데이트 완료"), message: Text("사용자 정보가 업데이트 되었습니다."), dismissButton: .default(Text("확인")){
                                self.dismiss()
                            })
                        } else{
                            return Alert(title: Text("오류"), message: Text("사용자 정보를 업데이트하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        }
                    })
                    .animation(.easeInOut)
            }
        }
    }
}

#Preview {
    UpdateUserInfoView(updateType: .PASSWORD)
}
