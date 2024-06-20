//
//  InheritanceGuardianSelectionView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/2/24.
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
                Text("Enter the E-Mail of the inheritance guardian or select an existing guardian to be the inheritance guardian.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 20)
                
                HStack{
                    Text("Select Guardian")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                    
                    if showProgress{
                        DotProgressView()
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
                    Text("Inheritance Guardians Added")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                    
                    if showProgress{
                        DotProgressView()
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
                if showOverlay{
                    DotProgressView()
                } else{
                    Button(action: {
                        if email != ""{
                            showOverlay = true
                            
                            helper.searchPatient(email: email){ result in
                                guard let result = result else{return}
                                
                                if result{
                                    selectedEmail = email
                                }
                                
                                showOverlay = result
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
                        }

                    }){
                        HStack{
                            Spacer()
                            
                            Text("Next Step")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.txt)
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }

                
            }.padding(20)
            .navigationTitle(Text("Select Inheritance Guardian"))
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
            .animation(Animation.easeInOut(duration: 0.5), value: true)
        }
    }
}

#Preview {
    InheritanceGuardianSelectionView()
}
