//
//  DiaryContentsModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import Foundation

struct DiaryContentsModel{
    let title: String
    let contents: String
    let date: String
    let emotion: DiaryEmotionModel
    let imgCount: Int
    
    init(title: String, contents: String, date: String, emotion: DiaryEmotionModel, imgCount: Int) {
        self.title = title
        self.contents = contents
        self.date = date
        self.emotion = emotion
        self.imgCount = imgCount
    }
}
