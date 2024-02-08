//
//  DigitalInheritanceAlertModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/3/24.
//

import Foundation

enum DigitalInheritanceAlertType: Error, LocalizedError{
    case USER_DOES_NOT_EXISTS
    case SUCCESS
    case FAIL
    case REMOVE_SUCCESS
    case REMOVE_FAIL
    
    var failureReason: String?{
        switch self{
        case .USER_DOES_NOT_EXISTS:
            return "일치하는 사용자 정보가 없습니다."
            
        case .SUCCESS:
            return "유산 관리자가 추가되었습니다."
            
        case .FAIL:
            return "유산 관리자를 추가하는 중 문제가 발생했습니다."
            
        case .REMOVE_SUCCESS:
            return "유산 관리자가 제거되었습니다."
            
        case .REMOVE_FAIL:
            return "유산 관리자를 제거하는 중 문제가 발생했습니다."

        }
    }
    
    var recoverySuggestion: String?{
        switch self{
        case .USER_DOES_NOT_EXISTS:
            return "입력한 정보를 다시 확인하십시오."
            
        case .SUCCESS:
            return "유산 관리자가 정상적으로 추가되었습니다."
            
        case .REMOVE_SUCCESS:
            return "유산 관리자가 정상적으로 제거되었습니다."
            
        case .FAIL, .REMOVE_FAIL:
            return "네트워크 상태를 확인하거나 나중에 다시 시도하십시오."
        }
    }
    
    var errorDescription: String?{
        switch self{
        case .USER_DOES_NOT_EXISTS:
            return "일치하는 사용자 정보 없음"
            
        case .SUCCESS:
            return "추가 완료"
            
        case .REMOVE_SUCCESS:
            return "제거 완료"
            
        case .FAIL, .REMOVE_FAIL:
            return "오류"
        }
    }
}
