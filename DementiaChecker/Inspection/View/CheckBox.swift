//
//  CheckBox.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/12/24.
//

import SwiftUI

struct CheckBox: View {
    @Binding var isChecked: Bool
    let title: String
    
    var body: some View {
        HStack{
            Button(action: {
                isChecked.toggle()
            }){
                Image(systemName: isChecked ? "checkmark" : "")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color.txt)
                
            }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
            
            Spacer().frame(width: 10)
            
            Text(title)
                .foregroundStyle(Color.txt)
            
            Spacer()
        }
    }
}

#Preview {
    CheckBox(isChecked: .constant(false), title: "Title")
}
