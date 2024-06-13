//
//  UserTypeSelectionView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/2/24.
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
                
                Text("Welcome!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)

                Text("Please select the type of user to sign up.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                                
                Spacer().frame(height: 20)

                HStack{
                    NavigationLink(destination: SignUpView(userType: .GUARDIAN)){
                        VStack{
                            Image(systemName: "figure.and.child.holdinghands")
                                .foregroundStyle(Color.txt)
                            
                            Text("Guardian")
                                .foregroundStyle(Color.txt)
                        }.frame(width: 120, height: 80)
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 5, cornerRadius: 15))
                    
                    NavigationLink(destination: SignUpView(userType: .PATIENT)){
                        VStack{
                            Image(systemName: "figure.arms.open")
                                .foregroundStyle(Color.txt)

                            Text("Patient")
                                .foregroundStyle(Color.txt)
                        }.padding(20)
                            .frame(width: 120, height: 80)
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 5, cornerRadius: 15))
                }
                
                Spacer()
            }.padding(20)
                .animation(Animation.easeInOut(duration: 0.5), value: true)

                .navigationTitle(Text("User Type Selection"))
        }
    }
}

#Preview {
    UserTypeSelectionView()
}
