//
//  UserInfoView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/9/24.
//

import SwiftUI

struct UserInfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var helper: UserManagement
    
    @State private var guardians: [UserInfoModel] = []
    @State private var showProgress = false
    @State private var alertType: UserManagementAlertType? = nil
    @State private var showAlert = false
    @State private var showSignInView = false
    @State private var homeAddress = ""
    @State private var workAddress = ""
    
    @AppStorage("authInfo") var authInfo = ""

    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                ScrollView{
                    VStack{
                        Image("ic_appstore")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .shadow(radius: 15)
                        
                        Text(helper.userInfo?.name ?? "Unknown User")
                            .foregroundStyle(Color.txt)
                            .fontWeight(.semibold)
                        
                        Text(helper.userInfo?.email ?? "")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                        
                        Spacer().frame(height: 10)

                        HStack{
                            Image(systemName: "house.fill")
                                .font(.caption)
                                .foregroundStyle(Color.gray)

                            Text(homeAddress)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        if helper.userInfo?.job ?? "" != ""{
                            Spacer().frame(height: 10)
                            
                            HStack{
                                Image(systemName: "person.2.badge.gearshape.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Text(helper.userInfo?.job ?? "")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)

                            }
                            
                            Spacer().frame(height: 10)
                            
                            HStack{
                                Image(systemName: "building.2.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Text(workAddress)
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)

                            }

                        }
                        
                        Spacer().frame(height: 10)

                        HStack{
                            Image(systemName: "figure.stand")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("\(helper.userInfo?.gender ?? "Unknown Gender") (Age: \(Int(helper.getAge()))) | \(helper.userInfo?.tall ?? "")cm, \(helper.userInfo?.weight ?? "")kg")
                                .font(.caption)
                                .foregroundStyle(Color.gray)

                        }

                        Spacer().frame(height: 20)
                        
                        
                        HStack{
                            Text("Guardians")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        Divider()
                        
                        Spacer().frame(height: 10)
                        
                        if guardians.isEmpty{
                            Text("There are no registered guardians")
                                .foregroundStyle(Color.gray)
                            
                        } else{
                            LazyVStack{
                                ForEach(guardians.indices, id: \.self){ index in
                                    Button(action: {
                                        
                                    }){
                                        InteritanceGuardianListModel(name: guardians[index].name, email: guardians[index].email)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                    
                                }
                            }
                        }
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            Text("Change User Information")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        Divider()
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            NavigationLink(destination: UpdateUserInfoView(updateType: .PASSWORD).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "key.fill")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Password")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                            
                            Spacer().frame(width: 20)
                            
                            NavigationLink(destination: UpdateUserInfoView(updateType: .BIRTHDAY).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "calendar")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Birthday")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                        }
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            NavigationLink(destination: UpdateUserInfoView(updateType: .NAME).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Name")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                            
                            Spacer().frame(width: 20)
                            
                            NavigationLink(destination: UpdateUserInfoView(updateType: .PHONE).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "phone.fill")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Contact")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                        }
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            NavigationLink(destination: UpdateUserInfoView(updateType: .HOME_ADDRESS).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "house.fill")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Home Address")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                            
                            Spacer().frame(width: 20)
                            
                            NavigationLink(destination: UpdateUserInfoView(updateType: .WORK_ADDRESS).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "building.2.fill")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Job")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                        }
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            NavigationLink(destination: UpdateUserInfoView(updateType: .TALL).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "figure.stand")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Tall")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                            
                            Spacer().frame(width: 20)
                            
                            NavigationLink(destination: UpdateUserInfoView(updateType: .WEIGHTS).environmentObject(helper)){
                                VStack{
                                    Image(systemName: "gauge")
                                        .foregroundStyle(Color.txt)
                                        .font(.title)
                                    
                                    Text("Weight")
                                        .foregroundStyle(Color.txt)
                                }.padding()
                                    .frame(width: 120, height: 100)
                            }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 0, cornerRadius: 15))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "person.crop.artframe")
                            .foregroundStyle(Color.gray)
                        
                        Spacer().frame(height: 10)
                        
                        Text("To add or remove a Heritage Manager, go to the Heritage Manager page on the More tab.")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer().frame(height: 20)
                        
                        if showProgress{
                            DotProgressView()
                        } else{
                            HStack {
                                Button(action : {
                                    showProgress = true
                                    
                                    helper.signOut(){ result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        
                                        if result{
                                            if authInfo.contains(", "){
                                                authInfo = ""
                                            }
                                            
                                            showSignInView = true
                                        } else{
                                            alertType = .SIGN_OUT_FAIL
                                            showAlert = true
                                        }
                                    }
                                }){
                                    Text("Sign Out")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .underline(true, color : .gray)
                                }
                                
                                Text("or")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Button(action : {
                                    showProgress = true
                                    
                                    helper.cancelMembership(){ result in
                                        guard let result = result else{return}
                                        
                                        showProgress = false
                                        
                                        if result{
                                            if authInfo.contains(", "){
                                                authInfo = ""
                                            }
                                            
                                            showSignInView = true
                                        } else{
                                            alertType = .DELETE_MEMBERSHIP_FAIL
                                            showAlert = true
                                        }
                                    }
                                }){
                                    Text("Cancel Membership")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .underline(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: .gray)
                                }
                            }
                        }
                    }
                }.padding(20)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading,
                                    content: {
                            Button(action: { dismiss() }){
                                Image(systemName: "xmark")
                            }
                        })
                    }
                    .alert(isPresented: $showAlert, error: alertType){ _ in

                    } message: {error in
                        Text(error.recoverySuggestion ?? "")
                    }
                    .onAppear{
                        helper.getGuardians(){ result in
                            guard let result = result else{return}
                            
                            self.guardians = result
                        }
                    }
                    .navigationTitle(Text("Profile"))
                    .animation(Animation.easeInOut(duration: 0.5), value: true)
                    .fullScreenCover(isPresented: $showSignInView, content: {
                        SignInView()
                    })
                    .onAppear{
                        let homeGeocode = helper.userInfo?.homeAddress
                        let workGeocode = helper.userInfo?.workAddress
                        let locationHelper = LocationHelper()
                        
                        if homeGeocode != "" && homeGeocode != nil{
                            let homeGeocode_split = homeGeocode!.split(separator: ", ")
                            
                            locationHelper.reverseGeocode(geoCode: "\(homeGeocode_split[0]),\(homeGeocode_split[1])", completion: { address in
                                guard let address = address else{return}
                                
                                homeAddress = address
                            })
                        }
                        
                        if workGeocode != "" && workGeocode != nil{
                            let workGeocode_split = workGeocode!.split(separator: ", ")
                            
                            locationHelper.reverseGeocode(geoCode: "\(workGeocode_split[0]),\(workGeocode_split[1])", completion: { address in
                                guard let address = address else{return}
                                
                                workAddress = address
                            })
                        }

                    }
                
            }
        }
        
    }
}

#Preview {
    UserInfoView().environmentObject(UserManagement())
}
