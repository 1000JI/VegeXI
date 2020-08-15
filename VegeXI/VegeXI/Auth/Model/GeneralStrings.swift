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
    case notification
    case emptyNotification
    case share
    
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
        case .notification:
            return "알림"
        case .emptyNotification:
            return "알림이 없습니다"
        case .share:
            return "공유하기"
        }
    }
}


enum SharePostStrings {
    case vegeType
    case category
    case setShareMode
    case shareModeInfo
    
    func generateString() -> String {
        switch self {
        case .vegeType:
            return "이 글의 채식타입"
        case .category:
            return "카테고리"
        case .setShareMode:
            return "공개설정"
        case .shareModeInfo:
            return "* 공개설정을 하지 않은 글은 마이페이지에서 확인할 수 있습니다."
        }
    }
}

enum MyPageStrings {
    case barTitle
    case unknownNickname
    case unknownVegeType
    case noPost
    case noBookmark
    case myPost
    case myBookmark
    
    func generateString() -> String {
        switch self {
        case .barTitle:
            return "마이페이지"
        case . unknownNickname:
            return "No Nickname"
        case .unknownVegeType:
            return "지향하는 채식타입을 설정해보세요"
        case .noPost:
            return "첫번째 글을 남겨보세요🍅"
        case .noBookmark:
            return "좋은 글을 저장해보세요 🥦"
        case .myPost:
            return "내 글"
        case .myBookmark:
            return "북마크"
        }
    }
}

enum EditProfileStrings {
    case barTitle
    case nickname
    case vegeType
    case confirm
    case camera
    case album
    case cancel
    
    func generateString() -> String {
        switch self {
        case .barTitle:
            return "내 프로필 편집"
        case .nickname:
            return "닉네임"
        case .vegeType:
            return "지향하는 채식타입"
        case .confirm:
            return "확인"
        case .camera:
            return "사진 촬영"
        case .album:
            return "앨범에서 선택"
        case .cancel:
            return "취소"
        }
    }
}

enum SettingViewStrings {
    case barTitle
    case bugReportingNoAvailable
    
    func generateString() -> String {
        switch self {
        case .barTitle:
            return "설정"
        case .bugReportingNoAvailable:
            return """
            이 디바이스에서는
            지원하지 않는 기능입니다.
"""
        }
    }
}
