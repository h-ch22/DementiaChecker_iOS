//
//  HealthListModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI

struct HealthListModel: View {
    @Environment(\.colorScheme) var colorScheme
    
    let symbol: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: symbol)
                    .font(.caption)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
            }
            
            Text(value)
                .foregroundStyle(color)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background)
                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
        )
        .frame(width: (UIScreen.main.bounds.width * 0.8) / 2, height: 80)

    }
}

#Preview {
    HealthListModel(symbol: "heart.fill", title: "Heartrate", value: "0 BPM", color: Color.red)
}
