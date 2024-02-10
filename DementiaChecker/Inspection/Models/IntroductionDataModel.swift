//
//  InspectionIntroductionDataModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import Foundation

struct IntroductionDataModel: Hashable{
    static func == (lhs: IntroductionDataModel, rhs: IntroductionDataModel) -> Bool {
        return lhs.title == rhs.title
    }
    
    var icon: String
    var title: String
    var description: String
    
    init(icon: String, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}
