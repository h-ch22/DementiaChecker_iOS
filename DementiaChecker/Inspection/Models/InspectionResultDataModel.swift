//
//  InspectionResultDataModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import Foundation

struct InspectionResultDataModel: Hashable{
    var type: InspectionResultTypeModel
    var percentageOfNormal: Float
    var percentageOfMCI: Float
    var percentageOfDementia: Float
}
