//
//  SignInStrings.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum SignInStrings {
    case email
    case password
    case nickname
    
    func generateString() -> String {
        switch self {
        case .email:
            return "이메일"
        case .password:
            return "비밀번호"
        case .nickname:
            return "닉네임"
        }
    }
}
