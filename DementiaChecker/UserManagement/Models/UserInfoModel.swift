//
//  UserInfoModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import Foundation

struct UserInfoModel: Hashable{
    var email: String
    var name: String
    var phone: String
    var birthDay: String
    var patientEmail: String
    var userType: UserTypeModel
    
    init(email: String, name: String, phone: String, birthDay: String, patientEmail: String, userType: UserTypeModel) {
        self.email = email
        self.name = name
        self.phone = phone
        self.birthDay = birthDay
        self.patientEmail = patientEmail
        self.userType = userType
    }
}
