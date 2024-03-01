//
//  UserManagementAlertType.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import Foundation

enum UserManagementAlertType: Error, LocalizedError{
    case UNKNOWN_USER
    case PASSWORD_MISMATCH
    case EMAIL_ALREADY_IN_USE
    case INCORRECT_EMAIL_TYPE
    case WEAK_PASSWORD
    case UNKNOWN_ERROR
    case PATIENT_EMAIL_DOES_NOT_FOUND
    case SIGN_OUT_FAIL
    case DELETE_MEMBERSHIP_FAIL
    case SUCCESS
    
    var failureReason: String?{
        switch self{
        case .UNKNOWN_USER:
            return "No matching user information found."
            
        case .PASSWORD_MISMATCH:
            return "Passwords do not match."
            
        case .EMAIL_ALREADY_IN_USE:
            return "Email is already in use."
            
        case .INCORRECT_EMAIL_TYPE:
            return "Invalid email format."
            
        case .WEAK_PASSWORD:
            return "Weak password detected."
            
        case .UNKNOWN_ERROR:
            return "An unknown error occurred."
            
        case .PATIENT_EMAIL_DOES_NOT_FOUND:
            return "Patient email not found."
            
        case .SUCCESS:
            return ""
            
        case .SIGN_OUT_FAIL:
            return "Failed to sign out."
            
        case .DELETE_MEMBERSHIP_FAIL:
            return "Failed to delete membership."
        }
    }
    
    var recoverySuggestion: String?{
        switch self{
        case .UNKNOWN_USER:
            return "Please check the entered information again."
            
        case .PASSWORD_MISMATCH:
            return "Please double-check the entered password and password confirmation."
            
        case .EMAIL_ALREADY_IN_USE:
            return "Try again with a different email or attempt password reset."
            
        case .INCORRECT_EMAIL_TYPE:
            return "Please enter a valid email address."
            
        case .WEAK_PASSWORD:
            return "For security, enter a password with at least 6 characters."
            
        case .UNKNOWN_ERROR:
            return "Please check network status or try again later."
            
        case .PATIENT_EMAIL_DOES_NOT_FOUND:
            return "Please double-check the patient email."
            
        case .SUCCESS:
            return ""
            
        case .SIGN_OUT_FAIL, .DELETE_MEMBERSHIP_FAIL:
            return "Check for normal login status, network status, or try again later."
        }
    }
    
    var errorDescription: String?{
        switch self{
        case .UNKNOWN_USER:
            return "No matching user information"
            
        case .PASSWORD_MISMATCH:
            return "Password mismatch"
            
        case .EMAIL_ALREADY_IN_USE:
            return "Email already in use"
            
        case .INCORRECT_EMAIL_TYPE:
            return "Invalid email format"
            
        case .WEAK_PASSWORD:
            return "Weak password"
            
        case .UNKNOWN_ERROR:
            return "Error"
            
        case .PATIENT_EMAIL_DOES_NOT_FOUND:
            return "Patient email not found"
            
        case .SUCCESS:
            return ""
            
        case .SIGN_OUT_FAIL, .DELETE_MEMBERSHIP_FAIL:
            return "Error"
        }
    }
}
