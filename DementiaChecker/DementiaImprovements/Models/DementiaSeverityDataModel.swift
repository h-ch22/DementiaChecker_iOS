//
//  DementiaSeverityDataModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import Foundation

struct DementiaSeverityDataModel: Hashable {
    static func == (lhs: DementiaSeverityDataModel, rhs: DementiaSeverityDataModel) -> Bool {
        return lhs.title == rhs.title
    }
    
    var icon: String
    var title: String
    var description: String
    var IQLevel: String
    
    init(icon: String, title: String, description: String, IQLevel: String) {
        self.icon = icon
        self.title = title
        self.description = description
        self.IQLevel = IQLevel
    }
}
