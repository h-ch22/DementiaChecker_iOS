//
//  HospitalDetailsMapViewController.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/2/24.
//

import Foundation
import UIKit
import SwiftUI
import NMapsMap

class HospitalDetailsMapViewController: UIViewController{
    let marker = NMFMarker()
    let location: NMGLatLng!
    let hospitalName: String
    
    var naverMapView: NMFNaverMapView!
    
    init(location: NMGLatLng!, hospitalName: String) {
        self.location = location
        self.hospitalName = hospitalName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder){
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width : UIScreen.main.bounds.width - 40, height : UIScreen.main.bounds.height / 3)
        
        naverMapView = NMFNaverMapView(frame: view.frame)
        naverMapView.showZoomControls = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = false

        marker.position = location
        marker.captionText = hospitalName
        
        let cameraUpdate = NMFCameraUpdate(scrollTo : location)
        naverMapView.mapView.moveCamera(cameraUpdate)
                
        marker.mapView = naverMapView.mapView
        view.addSubview(naverMapView)
    }
}
