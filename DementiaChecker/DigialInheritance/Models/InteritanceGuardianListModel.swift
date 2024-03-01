//
//  InteritanceGuardianListModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/2/24.
//

import SwiftUI

struct InteritanceGuardianListModel: View {
    let name: String
    let email: String
    
    var body: some View {
        HStack{
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
            
            Spacer().frame(width: 10)
            
            VStack{
                HStack{
                    Text(name)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                HStack{
                    Text(email)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                }
            }
            
            Spacer()
        }.padding(20)
    }
}

#Preview {
    InteritanceGuardianListModel(name: "Name", email: "E-Mail")
}
