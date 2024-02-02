//
//  LocationDataModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/1/24.
//

import Foundation

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
    
    init(centerName: String, centerType: String, roadAddr: String, latitude: Double, longitude: Double, doctorCount: Int, nurseCount: Int, scrcsCount: Int, tel: String) {
        self.centerName = centerName
        self.centerType = centerType
        self.roadAddr = roadAddr
        self.latitude = latitude
        self.longitude = longitude
        self.doctorCount = doctorCount
        self.nurseCount = nurseCount
        self.scrcsCount = scrcsCount
        self.tel = tel
    }
}
