//
//  NewMorphButtonStyle.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI

struct NewMorphButtonStyle: ButtonStyle {
    let foreground: Color
    var paddingValue: CGFloat = 20
    var cornerRadius: CGFloat = 50
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(paddingValue)
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(foreground)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.txt, Color.clear)))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(foreground, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(Color.clear, Color.txt)))
                            )
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(foreground)
                            .shadow(color: Color.txt.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: foreground.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
            .animation(.easeInOut)
    }
}

struct CircleNewMorphButtonStyle: ButtonStyle {
    let foreground: Color
    let paddingValue: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(paddingValue)
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(foreground)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.txt, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(foreground, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.txt)))
                            )
                    } else {
                        Circle()
                            .fill(foreground)
                            .shadow(color: Color.txt.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: foreground.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
            .animation(.easeInOut)

    }
}
