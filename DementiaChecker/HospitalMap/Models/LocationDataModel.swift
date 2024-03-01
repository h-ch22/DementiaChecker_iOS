//
//  LocationDataModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/1/24.
//

import Foundation
import CoreLocation

struct LocationDataModel: Hashable{
    var centerName: String
    var centerType: String
    var roadAddr: String
    var latitude: Double
    var longitude: Double
    var doctorCount: Int
    var nurseCount: Int
    var scrcsCount: Int
    var tel: String
    var distance: CLLocationDistance?
    
    init(centerName: String, centerType: String, roadAddr: String, latitude: Double, longitude: Double, doctorCount: Int, nurseCount: Int, scrcsCount: Int, tel: String, distance: CLLocationDistance? = nil) {
        self.centerName = centerName
        self.centerType = centerType
        self.roadAddr = roadAddr
        self.latitude = latitude
        self.longitude = longitude
        self.doctorCount = doctorCount
        self.nurseCount = nurseCount
        self.scrcsCount = scrcsCount
        self.tel = tel
        self.distance = distance
    }
}
