//
//  DigitalInheritanceAlertModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/3/24.
//

import Foundation

enum DigitalInheritanceAlertType: Error, LocalizedError {
    case USER_DOES_NOT_EXISTS
    case SUCCESS
    case FAIL
    case REMOVE_SUCCESS
    case REMOVE_FAIL
    
    var failureReason: String? {
        switch self {
        case .USER_DOES_NOT_EXISTS:
            return "No matching user information found."
            
        case .SUCCESS:
            return "Digital inheritance manager has been added."
            
        case .FAIL:
            return "There was a problem adding the digital inheritance manager."
            
        case .REMOVE_SUCCESS:
            return "Digital inheritance manager has been removed."
            
        case .REMOVE_FAIL:
            return "There was a problem removing the digital inheritance manager."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .USER_DOES_NOT_EXISTS:
            return "Please double-check the entered information."
            
        case .SUCCESS:
            return "Digital inheritance manager has been successfully added."
            
        case .REMOVE_SUCCESS:
            return "Digital inheritance manager has been successfully removed."
            
        case .FAIL, .REMOVE_FAIL:
            return "Please check your network connection and try again later."
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .USER_DOES_NOT_EXISTS:
            return "No Matching User Information"
            
        case .SUCCESS:
            return "Added Successfully"
            
        case .REMOVE_SUCCESS:
            return "Removed Successfully"
            
        case .FAIL, .REMOVE_FAIL:
            return "Error"
        }
    }
}
