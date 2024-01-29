//
//  Logos.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct TextLogo: View {
    var body: some View {
        Text("**Dementia** Checker")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}

struct TextLogoRegular: View {
    var body: some View {
        Text("**Dementia** Checker")
    }
}

struct TextWithImageLogo: View{
    var body: some View{
        HStack{
            Image("ic_appstore")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text("**Dementia** Checker")
                .font(.title2)
        }
    }
}

struct TextWithImageLogo_Vertical: View{
    var body: some View{
        VStack{
            Image("ic_appstore")
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text("**Dementia** Checker")
                .font(.title2)
        }
    }
}

#Preview("TextLogo") {
    TextLogo()
}

#Preview("TextWithImageLogo"){
    TextWithImageLogo()
}

#Preview("TextWithImageLogo_Vertical"){
    TextWithImageLogo_Vertical()
}
