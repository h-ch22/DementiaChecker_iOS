//
//  AutoSignInDataModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/31/24.
//

import Foundation

class AutoSignInDataModel{
    var email: String = ""
    var password: String = ""
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
