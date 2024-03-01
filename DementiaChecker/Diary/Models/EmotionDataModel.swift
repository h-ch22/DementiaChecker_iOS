//
//  EmotionDataModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import Foundation

struct EmotionDataModel: Identifiable{
    var emotion: String
    var count: Int
    
    var id: String{emotion}
}
