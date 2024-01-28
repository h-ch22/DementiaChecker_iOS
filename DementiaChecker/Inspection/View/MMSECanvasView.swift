//
//  MMSECanvasView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI
import PencilKit

struct MMSECanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @State private var toolPicker = PKToolPicker()

    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        showToolPicker()
        #if targetEnvironment(simulator)
        canvas.drawingPolicy = .anyInput
        
        #else
        canvas.drawingPolicy = UIDevice.current.userInterfaceIdiom == .pad ? .pencilOnly : .anyInput
        
        #endif
                
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }
}

private extension MMSECanvasView{
    func showToolPicker(){
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
}
