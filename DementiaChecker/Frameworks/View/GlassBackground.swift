//
//  GlassBackground.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/3/24.
//

import SwiftUI

struct GlassBackground: View {
    let color: Color
    
    var body: some View {
        ZStack{
            RadialGradient(colors: [.clear, color],
                           center: .center,
                            startRadius: 1,
                            endRadius: 100)
            .opacity(0.6)
            
            Rectangle().foregroundStyle(color)
        }.opacity(0.2)
            .blur(radius: 2)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    GlassBackground(color: Color.accent)
}
