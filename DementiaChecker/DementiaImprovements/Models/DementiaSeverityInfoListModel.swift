//
//  DementiaSeverityInfoListModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI

struct DementiaSeverityInfoListModel: View {
    let data: DementiaSeverityDataModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: data.icon)
                
                VStack(alignment: .leading){
                    Text(data.title)
                        .fontWeight(.semibold)
                    
                    Text("\(data.description)")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
            }
            
            Spacer().frame(height: 10)
            
            HStack{
                Image(systemName: "brain.fill")
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
                
                Text("IQ Level: \(data.IQLevel)")
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}

#Preview {
    DementiaSeverityInfoListModel(data: DementiaSeverityDataModel(icon: "magnifyingglass", title: "Title", description: "Description", IQLevel: "0"))
}
