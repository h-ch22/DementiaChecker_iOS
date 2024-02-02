//
//  MapView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/1/24.
//

import UIKit
import SwiftUI
import NMapsMap

class MapView: UIViewController, CLLocationManagerDelegate{
    var mapView: NMFNaverMapView!
    var locationManager = CLLocationManager()

    let data: [LocationDataModel]
    
    init(data: [LocationDataModel]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.2)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        mapView = NMFNaverMapView(frame: view.frame)
        mapView.showZoomControls = true
        mapView.showCompass = true
        mapView.showIndoorLevelPicker = true
        mapView.showLocationButton = true
        mapView.mapView.isIndoorMapEnabled = true
        
        view.addSubview(mapView)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601,
                                                                   lng: locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989))
            
            mapView.mapView.moveCamera(cameraUpdate)
            
        }
        
        placeMarkers()
    }
    
    private func placeMarkers(){
        DispatchQueue.global(qos: .default).async{
            var markers = [NMFMarker]()
            
            for d in self.data{
                let marker = NMFMarker(position: NMGLatLng(lat: d.latitude, lng: d.longitude))
                marker.captionText = d.centerName
                            
                markers.append(marker)
            }
            
            DispatchQueue.main.async {
                for marker in markers{
                    marker.mapView = self.mapView.mapView
                }
            }
        }
    }
}
