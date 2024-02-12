//
//  ClassInspectionResultDataModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/12/24.
//

import Foundation

struct ClassInspectionResultDataModel: Hashable{
    var max: InspectionResultTypeModel
    var percentageOfNormal: Float
    var percentageOfMCI: Float
    var percentageOfDementia: Float
    
    func getTypeAsString() -> String{
        switch self.max {
        case .NORMAL:
            return "NORMAL"
            
        case .MCI:
            return "MCI"
            
        case .DEMENTIA:
            return "DEMENTIA"
        }
    }
}
