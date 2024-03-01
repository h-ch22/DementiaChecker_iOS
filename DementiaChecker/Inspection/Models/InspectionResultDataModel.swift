//
//  InspectionResultDataModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import Foundation

struct InspectionResultDataModel: Hashable{
    var type: InspectionResultTypeModel
    var percentageOfNormal: Float
    var percentageOfMCI: Float
    var percentageOfDementia: Float
    
    func getTypeAsString() -> String{
        switch self.type {
        case .NORMAL:
            return "NORMAL"
            
        case .MCI:
            return "MCI"
            
        case .DEMENTIA:
            return "DEMENTIA"
        }
    }
}
