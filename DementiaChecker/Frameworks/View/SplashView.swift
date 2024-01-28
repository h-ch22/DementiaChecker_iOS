//
//  SplashView.swift
//  DementiaChecker
//
//  Created by Ha Changjin on 1/16/24.
//

import SwiftUI

struct SplashView: View {
    @State private var changeView = false
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])

            VStack{
                Spacer()
                
                TextWithImageLogo_Vertical()
                
                Spacer()
                
                ProgressView()
            }.padding(20)
                .onAppear{
                    changeView = true
                }
                .fullScreenCover(isPresented: $changeView, content: {
                    SignInView()
                })
        }
    }
}

#Preview {
    SplashView()
}
