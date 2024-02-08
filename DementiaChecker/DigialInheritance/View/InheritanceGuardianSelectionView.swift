//
//  InheritanceGuardianSelectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/2/24.
//

import SwiftUI

struct InheritanceGuardianSelectionView: View {
    @EnvironmentObject var helper: UserManagement

    @State private var showProgress = true
    @State private var email = ""
    @State private var guardians: [UserInfoModel] = []
    @State private var inheritanceGuardians: [UserInfoModel] = []
    @State private var selectedIndex = 0
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var alertType: DigitalInheritanceAlertType? = nil
    @State private var selectedEmail = ""
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Text("유산 관리자의 E-Mail을 입력하거나, 기존의 보호자를 유산 관리자로 지정할 수 있습니다.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 20)
                
                HStack{
                    Text("보호자 선택")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                    
                    if showProgress{
                        ProgressView()
                    }
                }
                
                Spacer().frame(height: 20)
                
                LazyVStack{
                    ForEach(guardians.indices, id: \.self){ index in
                        Button(action: {
                            showOverlay = true
                            
                            helper.setInheritanceGuardian(email: guardians[index].email, completion: { result in
                                guard let result = result else{return}
                                
                                showOverlay = false
                                alertType = result ? .SUCCESS : .FAIL
                                showAlert = true
                            })
                        }){
                            InteritanceGuardianListModel(name: guardians[index].name, email: guardians[index].email)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }

                    }
                }
                
                Spacer().frame(height: 20)
                
                HStack{
                    Text("이미 추가된 유산 관리자")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                    
                    if showProgress{
                        ProgressView()
                    }
                }
                
                Spacer().frame(height: 20)

                LazyVStack{
                    ForEach(inheritanceGuardians.indices, id: \.self){ index in
                        Button(action: {
                            showOverlay = true
                            
                            helper.removeInheritanceGuardian(email: guardians[index].email, completion: { result in
                                guard let result = result else{return}
                                
                                showOverlay = false
                                alertType = result ? .REMOVE_SUCCESS : .REMOVE_FAIL
                                showAlert = true
                            })
                        }){
                            InteritanceGuardianListModel(name: guardians[index].name, email: guardians[index].email)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }

                    }
                }
                
                Spacer()
                
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
                
                Spacer()
                
                if email != ""{
                    Button(action: {
                        showOverlay = true
                        
                        helper.searchPatient(email: email){ result in
                            guard let result = result else{return}
                            
                            if result{
                                selectedEmail = email
                            }
                            
                            showOverlay = !result
                            alertType = result ? nil : .USER_DOES_NOT_EXISTS
                            showAlert = !result
                            
                            if result{
                                helper.setInheritanceGuardian(email: email, completion: { result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    alertType = result ? .SUCCESS : .FAIL
                                    showAlert = true
                                })
                            }
                        }
                    }){
                        HStack{
                            Text("다음 단계로")
                            
                            Image(systemName: "chevron.right")
                        }.padding(20)
                            .padding([.horizontal], 80)
                            .background(
                                .ultraThickMaterial
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                }
                
            }.padding(20)
            .navigationTitle(Text("유산 관리자 선택하기"))
            .overlay(ProgressOverlay().isHidden(!showOverlay))
            .onAppear{
                helper.getGuardians(){ result in
                    guard let result = result else{return}
                    
                    self.guardians = result
                }
                
                helper.getInheritanceGuardian(completion: { result in
                    guard let result = result else{return}
                    
                    self.inheritanceGuardians = result
                    
                    showProgress = false
                })
            }
            .alert(isPresented: $showAlert, error: alertType){ _ in

            } message: {error in
                Text(error.recoverySuggestion ?? "")
            }
            .animation(.easeInOut)
        }
    }
}

#Preview {
    InheritanceGuardianSelectionView()
}
