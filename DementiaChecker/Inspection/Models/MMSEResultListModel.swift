//
//  MMSEResultListModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/14/24.
//

import SwiftUI

struct MMSEResultListModel: View {
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    let isCorrect: String
    
    var body: some View {
        VStack{
            Text(title)
                .fontWeight(.semibold)
                .foregroundStyle(Color.txt)
            
            Spacer().frame(height: 10)

            Text(isCorrect)
                .foregroundStyle(isCorrect == "Correct" ? Color.blue : isCorrect == "Correctness" ? Color.txt : Color.red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background)
                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
        )
        .frame(height: 150)
    }
}
