//
//  HospitalMapHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/1/24.
//

import Foundation
import SwiftyJSON

class HospitalMapHelper: ObservableObject{
    @Published var hospitalList: [LocationDataModel] = []
    
    func parse(completion: @escaping(_ result: Bool?) -> Void){
        if let resource = Bundle.main.path(forResource: "center_datas", ofType: "json", inDirectory: "include"){
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: resource), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{
                    if let fields = jsonResult["records"] as? Array<Dictionary<String, AnyObject>>{
                        for field in fields{
                            hospitalList.append(
                                LocationDataModel(centerName: field["치매센터명"] as? String ?? "",
                                                  centerType: field["치매센터유형"] as? String ?? "",
                                                  roadAddr: field["소재지도로명주소"] as! String,
                                                  latitude: Double(field["위도"] as? String ?? "0.0") ?? 0.0,
                                                  longitude: Double(field["경도"] as? String ?? "0.0") ?? 0.0,
                                                  doctorCount: Int(field["의사인원수"] as? String ?? "0") ?? 0,
                                                  nurseCount: Int(field["간호사인원수"] as? String ?? "0") ?? 0,
                                                  scrcsCount: Int(field["사회복지사인원수"] as? String ?? "0") ?? 0,
                                                  tel: field["관리기관전화번호"] as? String ?? "")
                            )
                        }
                        
                        completion(true)
                        return
                    } else{
                        completion(false)
                        return
                    }
                    
                    
                } else{
                    completion(false)
                    return
                }
            } catch{
                print(error.localizedDescription)
                completion(false)
                return
            }
        } else{
            print("Cannot open JSON File")
            completion(false)
            return
        }
        
    }
}
