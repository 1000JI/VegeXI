//
//  GeneralStrings.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum GeneralStrings {
    case startButton
    case findPassword
    case signupWithEmail
    
    func generateString() -> String {
        switch self {
        case .startButton:
            return "시작하기"
        case .findPassword:
            return "비밀번호 찾기"
        case .signupWithEmail:
            return "이메일로 가입하기"
        }
    }
}
