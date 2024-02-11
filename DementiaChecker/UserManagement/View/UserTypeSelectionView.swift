//
//  UserTypeSelectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/2/24.
//

import SwiftUI

struct UserTypeSelectionView: View {
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Spacer()
                
                Image(systemName: "smiley.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.txt)
                
                Text("반가워요!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)

                Text("가입할 사용자의 종류를 선택해주세요.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                                
                Spacer().frame(height: 20)

                HStack{
                    NavigationLink(destination: SignUpView(userType: .GUARDIAN)){
                        VStack{
                            Image(systemName: "figure.and.child.holdinghands")
                                .foregroundStyle(Color.txt)
                            
                            Text("보호자")
                                .foregroundStyle(Color.txt)
                        }.frame(width: 120, height: 80)
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 5, cornerRadius: 15))
                    
                    NavigationLink(destination: SignUpView(userType: .PATIENT)){
                        VStack{
                            Image(systemName: "figure.arms.open")
                                .foregroundStyle(Color.txt)

                            Text("환자 본인")
                                .foregroundStyle(Color.txt)
                        }.padding(20)
                            .frame(width: 120, height: 80)
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 5, cornerRadius: 15))
                }
                
                Spacer()
            }.padding(20)
                .animation(.easeInOut)

                .navigationTitle(Text("사용자 유형 선택"))
        }
    }
}

#Preview {
    UserTypeSelectionView()
}
