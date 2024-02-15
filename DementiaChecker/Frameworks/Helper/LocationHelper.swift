//
//  LocationHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/16/24.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class LocationHelper: NSObject, CLLocationManagerDelegate{
    private let locationManager = CLLocationManager()
    private let API_KEY = "wg1lmr2uds"
    private let API_SECRET = "etkEdOhXHoQ3wOF628HGAwSPHdSaoi8SvmU5RpGJ"
    private let GC_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
    private let RGC_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"
    
    func getCurrentLatLng() -> CLLocation?{
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        return self.locationManagerDidChangeAuthorization(locationManager)
    }
    
    private func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) -> CLLocation? {
        if CLLocationManager.locationServicesEnabled(){
            return locationManager.location
        }
        
        return nil
    }
    
    func geoCode(address: String, completion: @escaping(_ result: String?) -> Void){
        let header_key = HTTPHeader(name : "X-NCP-APIGW-API-KEY-ID", value : API_KEY)
        let header_secret = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API_SECRET)
        let headers = HTTPHeaders([header_key, header_secret])
        
        let parameters: Parameters = [
            "query": address
        ]
        
        let request = AF.request(GC_URL, method: .get, parameters: parameters, headers: headers)

        request.validate().responseJSON(){response in
            switch response.result {
                
            case .success(let success):
                let json = JSON(success)
                
                let x = json["addresses"][0]["x"].string ?? ""
                let y = json["addresses"][0]["y"].string ?? ""
                                
                completion("\(x), \(y)")

            case .failure(let failure):
                print(failure)
                completion("")
                return
                
            default:
                completion("")
                fatalError()
            }
        }
    }
    
    func reverseGeocode(geoCode: String, completion: @escaping(_ result: String?) -> Void){
        let header_key = HTTPHeader(name : "X-NCP-APIGW-API-KEY-ID", value : API_KEY)
        let header_secret = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API_SECRET)
        let headers = HTTPHeaders([header_key, header_secret])
        
        let parameters : Parameters = [
            "coords" : geoCode,
            "output" : "json",
            "orders" : "addr,admcode,roadaddr"
        ]
        
        let alamo = AF.request(RGC_URL, method: .get, parameters: parameters, headers: headers)
        
        alamo.validate().responseJSON(){response in
                switch response.result{
                case .success(let value as [String : Any]):
                    let json = JSON(value)
                    let data = json["results"]
                    let state = data[0]["region"]["area1"]["name"].string ?? ""
                    let address = data[0]["region"]["area2"]["name"].string ?? ""
                    let address_detail = data[0]["region"]["area3"]["name"].string ?? ""
                    let roadName = data[2]["land"]["name"].string ?? ""
                    let road = data[2]["land"]["number1"].string ?? ""
                    var roadCode = data[2]["land"]["number2"].string ?? ""
                    let building = data[2]["land"]["addition0"]["value"].string ?? ""
                    
                    if roadCode != ""{
                        roadCode = "-" + roadCode
                    }
                    
                    completion("\(state) \(address) \(roadName) \(road)\(roadCode) \(building)")
                    return
                    
                case .failure(let error) :
                    print(error)
                    completion("")
                    
                    return
                    
                default:
                    completion("")
                    fatalError()
                }
                
            }
    }
    
    func reverseGeoCode(requestType: String, lat: String, lng: String, completion: @escaping(_ answer: String?) -> Void){
        let header_key = HTTPHeader(name : "X-NCP-APIGW-API-KEY-ID", value : API_KEY)
        let header_secret = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API_SECRET)
        let headers = HTTPHeaders([header_key, header_secret])
        
        let lat_double = Double(lat)!
        let lng_double = Double(lng)!
                
        let parameters : Parameters = [
            "coords" : "\(lng_double),\(lat_double)",
            "output" : "json",
            "orders" : "addr,admcode,roadaddr"
        ]
        
        let alamo = AF.request(RGC_URL, method: .get, parameters: parameters, headers: headers)
        
        alamo.validate().responseJSON(){response in
                switch response.result{
                case .success(let value as [String : Any]):
                    let json = JSON(value)
                    let data = json["results"]
                    let state = data[0]["region"]["area1"]["name"].string ?? ""
                    let address = data[0]["region"]["area2"]["name"].string ?? ""
                    let address_detail = data[0]["region"]["area3"]["name"].string ?? ""
                    let roadName = data[2]["land"]["name"].string ?? ""
                    let road = data[2]["land"]["number1"].string ?? ""
                    var roadCode = data[2]["land"]["number2"].string ?? ""
                    let building = data[2]["land"]["addition0"]["value"].string ?? ""
                    
                    if roadCode != ""{
                        roadCode = "-" + roadCode
                    }
                    
                    if requestType == "State"{
                        completion(state)
                    } else if requestType == "Building"{
                        completion(building)
                    }
                    
                case .failure(let error) :
                    print(error)
                    completion("")
                    
                    return
                    
                default:
                    completion("")
                    fatalError()
                }
                
            }
    }
}
