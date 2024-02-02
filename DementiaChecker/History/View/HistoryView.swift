//
//  HistoryView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    HistoryView()
}
