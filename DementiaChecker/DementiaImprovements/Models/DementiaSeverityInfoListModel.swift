//
//  DementiaSeverityInfoListModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
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
                
                Text("IQ 수준: \(data.IQLevel)")
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}

#Preview {
    DementiaSeverityInfoListModel(data: DementiaSeverityDataModel(icon: "magnifyingglass", title: "타이틀", description: "설명", IQLevel: "0"))
}
