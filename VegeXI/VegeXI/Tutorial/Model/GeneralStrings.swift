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
    case sendButton
    case findPassword
    case signupWithEmail
    case searchFieldPlaceholder
    case recentSearchHistory
    case eraseAll
    case filterViewTitle
    case filterBottomViewTitle
    
    func generateString() -> String {
        switch self {
        case .startButton:
            return "시작하기"
        case .sendButton:
            return "보내기"
        case .findPassword:
            return "비밀번호 찾기"
        case .signupWithEmail:
            return "이메일로 가입하기"
        case .searchFieldPlaceholder:
            return "검색해보세요"
        case .recentSearchHistory:
            return "최근 검색어"
        case .eraseAll:
            return "모두 지우기"
        case .filterViewTitle:
            return "필터"
        case .filterBottomViewTitle:
            return "필터 적용"
        }
    }
}
