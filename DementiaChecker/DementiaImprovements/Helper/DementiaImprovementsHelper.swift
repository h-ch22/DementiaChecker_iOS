//
//  DementiaImprovementsHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import Foundation

class DementiaImprovementsHelper: ObservableObject{
    @Published var word = ""
    
    func getWord() -> String{
        do{
            let path = Bundle.main.path(forResource: "list_word", ofType: "csv", inDirectory: "include")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            var dataEncoded = String(data: data, encoding: .utf8)
            dataEncoded = dataEncoded?.replacingOccurrences(of: "\r", with: "")
            
            if let dataArr = dataEncoded?.components(separatedBy: ","){
                let index = Int.random(in: 0...dataArr.count-1)
                
                return dataArr[index]
            } else{
                return ""
            }
        } catch{
            print("Error reading CSV file")
            return ""
        }
    }
}
