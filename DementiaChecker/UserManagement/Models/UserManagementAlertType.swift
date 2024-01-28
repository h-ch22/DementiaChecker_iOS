//
//  UserManagementAlertType.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import Foundation

enum UserManagementAlertType: Error, LocalizedError{
    case UNKNOWN_USER
    case PASSWORD_MISMATCH
    case EMAIL_ALREADY_IN_USE
    case INCORRECT_EMAIL_TYPE
    case WEAK_PASSWORD
    case UNKNOWN_ERROR
    case SUCCESS
    
    var failureReason: String?{
        switch self{
        case .UNKNOWN_USER:
            return "일치하는 사용자 정보가 없습니다."
            
        case .PASSWORD_MISMATCH:
            return "비밀번호와 비밀번호 확인이 일치하지 않습니다."
            
        case .EMAIL_ALREADY_IN_USE:
            return "이미 사용 중인 E-Mail입니다."
            
        case .INCORRECT_EMAIL_TYPE:
            return "올바른 형식의 E-Mail이 아닙니다."
            
        case .WEAK_PASSWORD:
            return "안전하지 않은 비밀번호입니다."
            
        case .UNKNOWN_ERROR:
            return "오류"
            
        case .SUCCESS:
            return ""
        }
    }
    
    var recoverySuggestion: String?{
        switch self{
        case .UNKNOWN_USER:
            return "입력한 정보를 다시 확인하십시오."
            
        case .PASSWORD_MISMATCH:
            return "입력한 비밀번호와 비밀번호 확인을 다시 확인하십시오."
            
        case .EMAIL_ALREADY_IN_USE:
            return "다른 E-Mail로 재시도하거나, 비밀번호 재설정을 시도하십시오."
            
        case .INCORRECT_EMAIL_TYPE:
            return "올바른 형식의 E-Mail을 입력하십시오."
            
        case .WEAK_PASSWORD:
            return "보안을 위해 6자리 이상의 비밀번호를 입력하십시오."
            
        case .UNKNOWN_ERROR:
            return "네트워크 상태를 확인하거나 나중에 다시 시도하십시오."
            
        case .SUCCESS:
            return ""
        }
    }
    
    var errorDescription: String?{
        switch self{
        case .UNKNOWN_USER:
            return "일치하는 사용자 정보 없음"
            
        case .PASSWORD_MISMATCH:
            return "비밀번호 불일치"
            
        case .EMAIL_ALREADY_IN_USE:
            return "이미 사용 중인 E-Mail"
            
        case .INCORRECT_EMAIL_TYPE:
            return "올바르지 않은 형식의 E-Mail"
            
        case .WEAK_PASSWORD:
            return "안전하지 않은 비밀번호"
            
        case .UNKNOWN_ERROR:
            return "오류"
            
        case .SUCCESS:
            return ""
        }
    }
}
