//
//  InspectionIntroductionListModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import SwiftUI

struct InspectionIntroductionListModel: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack{
            Image(systemName: icon)
            
            VStack(alignment: .leading){
                Text(title)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    InspectionIntroductionListModel(icon: "magnifyingglass", title: "Title", description: "Description")
}
