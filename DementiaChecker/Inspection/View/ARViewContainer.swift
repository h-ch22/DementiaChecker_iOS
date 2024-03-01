//
//  ARViewContainer.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable{
    @Binding var isSuccess: Bool
    
    func makeUIView(context: Context) -> ARView{
        let arView = ARView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        let faceTrackingConfig = ARFaceTrackingConfiguration()
        arView.session.run(faceTrackingConfig)
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context){
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isSuccessful: $isSuccess)
    }
    
    class Coordinator: NSObject, ObservableObject, ARSessionDelegate{
        @Binding var isSuccessful: Bool
        
        init(isSuccessful: Binding<Bool>) {
            _isSuccessful = isSuccessful
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            if let faceAnchor = anchors.first as? ARFaceAnchor{
                let blendShapes = faceAnchor.blendShapes
                
                guard let leftEyeOpen = blendShapes[.eyeBlinkLeft] as? Float,
                      let rightEyeOpen = blendShapes[.eyeBlinkRight] as? Float else{return}
                
                if leftEyeOpen > 0.7 && rightEyeOpen > 0.7{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.isSuccessful = true
                    })
                }
             }
        }
    }
}
