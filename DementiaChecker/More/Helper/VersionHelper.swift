//
//  VersionHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import Foundation
import FirebaseFirestore

class VersionHelper: ObservableObject{
    @Published var version = ""
    @Published var build = ""
    
    @Published var latestVersion = ""
    @Published var latestBuild = ""
    
    private let db = Firestore.firestore()
    
    func getCurrnetVersion(){
        if let info: [String: Any] = Bundle.main.infoDictionary, let currentVersion: String = info["CFBundleShortVersionString"] as? String{
            version = currentVersion
        } else{
            version = "알 수 없음"
        }
        
        if let info: [String: Any] = Bundle.main.infoDictionary, let buildNumber: String = info["CFBundleVersion"] as? String{
            build = buildNumber
        } else{
            build = "알 수 없음"
        }
    }
    
    func getLatestVersion(completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Version").document("iOS").getDocument(){(document, error) in
            if error != nil{
                completion(false)
                return
            } else{
                self.latestVersion = document?.get("Version") as? String ?? ""
                self.latestBuild = document?.get("Build") as? String ?? ""
                
                completion(true)
                return
            }
        }
    }
}
