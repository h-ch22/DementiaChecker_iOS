//
//  UserInfoModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import Foundation

class UserInfoModel{
    var email: String
    var name: String
    var phone: String
    var birthDay: String
    
    init(email: String, name: String, phone: String, birthDay: String) {
        self.email = email
        self.name = name
        self.phone = phone
        self.birthDay = birthDay
    }
}
