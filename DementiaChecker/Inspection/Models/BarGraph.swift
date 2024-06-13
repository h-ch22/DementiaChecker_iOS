//
//  BarGraph.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI

struct BarGraph: View {
    let value: Float
    let color: Color
    let width: CGFloat = 100
    let height: CGFloat = 5
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(width: width , height: height)
                .opacity(0.3)
                .foregroundColor(color)
            
            Rectangle().frame(width: min(CGFloat(value)*width, width), height: self.height)
                .foregroundColor(color)
                .animation(Animation.linear(duration: 0.5), value: true)
        }.cornerRadius(45.0)
    }
}

#Preview {
    BarGraph(value: 0.8, color: Color.green)
}
