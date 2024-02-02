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
            LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Spacer()
                
                Image(systemName: "smiley.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                
                Text("반가워요!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)

                Text("가입할 사용자의 종류를 선택해주세요.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                                
                Spacer().frame(height: 20)

                HStack{
                    NavigationLink(destination: SignUpView(userType: .GUARDIAN)){
                        VStack{
                            Image(systemName: "figure.and.child.holdinghands")
                            Text("보호자")
                        }.padding(20)
                            .frame(width: 120, height: 80)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                    
                    NavigationLink(destination: SignUpView(userType: .PATIENT)){
                        VStack{
                            Image(systemName: "figure.arms.open")
                            Text("환자 본인")
                        }.padding(20)
                            .frame(width: 120, height: 80)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                }
                
                Spacer()
            }.padding(20)
                .navigationTitle(Text("사용자 유형 선택"))
        }
    }
}

#Preview {
    UserTypeSelectionView()
}
