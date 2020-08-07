//
//  SignUpStrings.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum SignUpStrings {
    case email
    case password
    case retypePassword
    case nickname
    case agreement
    case passwordInfo
    
    func generateString() -> String {
        switch self {
        case .email:
            return "아이디"
        case .password:
            return "비밀번호 최소 6자 이상"
        case .retypePassword:
            return "비밀번호 확인 최소 6자 이상"
        case .nickname:
            return "닉네임"
        case .agreement:
            return "느린채식의 서비스 이용약관, 개인정보 수집 및 이용에 동의합니다"
        case .passwordInfo:
            return """
            가입하신 메일 주소를 통해
            비밀번호를 변경하실 수 있습니다.
            """
        }
    }
}
