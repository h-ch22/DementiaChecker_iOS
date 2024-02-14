//
//  ResetPasswordView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/14/24.
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
                
                Text("비밀번호 재설정")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)
                
                Spacer().frame(height: 10)

                Text("아래 필드에 가입한 E-Mail을 입력하십시오.")
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

                            Text("비밀번호 재설정 메일 발송")
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
                if alertModel{
                    return Alert(title: Text("발송 완료"), message: Text("입력한 E-Mail로 비밀번호 재설정 메일이 발송되었습니다."), dismissButton: .default(Text("확인")))
                } else{
                    return Alert(title: Text("오류"), message: Text("비밀번호 재설정 메일을 발송하는 중 문제가 발생했습니다.\n가입한 계정이 맞는지 확인하거나, 네트워크 상태를 확인한 후 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                }
            })
        }
    }
}

#Preview {
    ResetPasswordView()
        .environmentObject(UserManagement())
}
