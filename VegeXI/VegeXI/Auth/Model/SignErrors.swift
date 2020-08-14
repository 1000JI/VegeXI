//
//  SignErrors.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/5/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum SignErrors {
    case unknown
    case unableToLogIn
    case fillEmail
    case invalidEmail
    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case fillPassword
    case weakPassword
    case passwordNotMatching
    case fillNickName
    case missingEmail
    case nicknameAlreadyInUse
    
    func generateErrorMessage() -> String {
        switch self {
        case .unknown:
            return "아이디와 비밀번호를 다시 확인해주세요."
        case .unableToLogIn:
            return "입력하신 아이디와 비밀번호가 일치하지 않습니다."
        case .fillEmail:
            return "이메일을 입력해주세요."
        case .invalidEmail:
            return "이메일 형식이 잘못되었어요."
        case .userNotFound:
            return "존재하지 않는 아이디입니다"
        case .wrongPassword:
            return "잘못된 비밀번호 입니다."
        case .emailAlreadyInUse:
            return "중복된 이메일 주소입니다."
        case .fillPassword:
            return "비밀번호를 입력해주세요."
        case .weakPassword:
            return "비밀번호는 6자 이상 입력해주세요."
        case .passwordNotMatching:
            return "비밀번호가 일치하지 않아요."
        case .fillNickName:
            return "닉네임을 입력해주세요."
        case .missingEmail:
            return "이메일 주소를 입력해주세요"
        case .nicknameAlreadyInUse:
            return "중복된 닉네임 입니다."
        }
    }
}
