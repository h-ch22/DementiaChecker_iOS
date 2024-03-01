//
//  ResetPasswordView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/14/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email = ""
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var alertModel = false
    
    @EnvironmentObject var helper: UserManagement
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Image(systemName: "key.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.txt)
                
                Spacer().frame(height: 20)
                
                Text("Reset Password")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)
                
                Spacer().frame(height: 10)

                Text("Please enter registered E-Mail on below field.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                
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
                
                if showProgress{
                    DotProgressView()
                } else{
                    Button(action: {
                        if email != ""{
                            showProgress = true
                            
                            helper.sendResetPasswordMail(email: email, completion: { result in
                                guard let result = result else{return}
                                
                                showProgress = false
                                alertModel = result
                                showAlert = true
                            })
                        }
                    }){
                        HStack{
                            Spacer()

                            Text("Send Password Reset E-Mail")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.txt)
                            
                            Spacer()
                        }
                            
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }

                
            }.animation(.easeInOut)
            .padding(20)
            .alert(isPresented: $showAlert, content: {
                if alertModel {
                    return Alert(title: Text("Sent"), message: Text("A password reset email has been sent to the provided email address."), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Error"), message: Text("There was an issue sending the password reset email.\nPlease make sure you have entered the correct account or check your network connection and try again."), dismissButton: .default(Text("OK")))
                }
            })
        }
    }
}

#Preview {
    ResetPasswordView()
        .environmentObject(UserManagement())
}
