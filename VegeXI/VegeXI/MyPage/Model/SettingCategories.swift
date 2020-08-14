//
//  SettingCategories.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

struct SettingCategories {
    
    static let instance = SettingCategories()
    
    let categoryInfo =
    [
        [
            "title": "푸시알림 설정",
            "subtitle": "",
            "info": "",
            "type": "switcher"
        ],
        [
            "title": "비밀번호 변경",
            "subtitle": "",
            "info": "",
            "type": "pager"
        ],
        [
            "title": "문의/버그신고",
            "subtitle": "",
            "info": "",
            "type": "pager"
        ],
        [
            "title": "느린채식 어플 응원하기",
            "subtitle": "별점과 코멘트는 큰 힘이 됩니다💚",
            "info": "",
            "type": "subtitle"
        ],
        [
            "title": "서비스 이용 약관",
            "subtitle": "",
            "info": "",
            "type": "pager"
        ],
        [
            "title": "개인정보 처리방침",
            "subtitle": "",
            "info": "",
            "type": "pager"
        ],
        [
            "title": "버전 정보",
            "subtitle": "",
            "info": "1.0.0",
            "type": "info"
        ],
        [
            "title": "로그아웃",
            "subtitle": "",
            "info": "",
            "type": "defualt"
        ],
    ]
    
}
