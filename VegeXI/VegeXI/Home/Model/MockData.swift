//
//  MockData.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

struct MockData {
    
    static var searchHistory = ["레시피", "이지호립밤", "주방세제", "Cat"]
    static var filterList = [
        ["채식타입":
            ["전체", "비건", "오보", "릭토", "락토오보", "페스코"]
        ],
        ["식단":
            ["한식", "일식", "중식", "양식", "동남아", "인도", "분식", "베이커리"]
        ],
        ["장소":
            ["식당", "카페", "생활"]
        ],
        ["제품":
            ["화장품", "생활용품", "패션"]
        ],
        ["컨텐츠":
            ["인플루언서", "책", "영화", "다큐"]
        ],
    ]
    
    static var newFilteredList = [
        ["지향하는 채식 타입":
            ["상관없음", "비건", "오보", "락토", "락토오보", "페스코"]
        ],
        ["식단":
            ["한식", "분식", "일식", "중식", "양식", "동남아", "인도·중동", "빵·커피", "술"]
        ],
        ["장소":
            ["식당", "베이커리·카페", "생활용품점", "전시회·박람회"]
        ],
        ["제품":
            ["화장품", "생활용품", "패션"]
        ],
        ["컨텐츠":
            ["인플루언서", "책", "영화", "다큐멘터리"]
        ],
    ]
    
    static var vegetarianInfo = [
        ["비건":
            ["carrot"]
        ],
        ["오보":
            ["carrot", "egg"]
        ],
        ["락토":
            ["carrot", "milk-2", "cheese-3"]
        ],
        ["락토오보":
            ["carrot", "milk-2", "cheese-3", "egg"]
        ],
        ["페스코":
            ["carrot", "milk-2", "egg", "meat"]
        ],
    ]
    
    static var notificationData = [
        [
            "profile": "",
            "nickname": "이죠",
            "system": "님이 회원님의 게시물에 댓글을 달았습니다:",
            "content": "우와 립밤이 너무 예뻐보여요😍",
            "image": "feed_Example",
            "time": "5시간 전",
        ],
        [
            "profile": "",
            "nickname": "도영도영",
            "system": "님이 회원님의 게시물에 댓글을 달았습니다:",
            "content": "오 저도 사서 써봐야겠네요. 추천 감사합니다",
            "image": "feed_Example",
            "time": "2일 전",
        ],
        [
            "profile": "",
            "nickname": "이죠",
            "system": "님 외 10명이 회원님의 게시물을 좋아합니다.",
            "content": "",
            "image": "feed_Example",
            "time": "지난 주",
        ],
        [
            "profile": "slowvegexicon",
            "nickname": "",
            "system": "느린채식이 최신 버전으로 업데이트 되었습니다.",
            "content": "",
            "image": "",
            "time": "2주 전",
        ],
        [
            "profile": "",
            "nickname": "천지",
            "system": "님이 회원님의 게시물에 댓글을 달았습니다:",
            "content": "저도 이거 쓰고 있는데 좋더라고요!",
            "image": "",
            "time": "지난 달",
        ],
        [
            "profile": "",
            "nickname": "천지",
            "system": "님 외 4명이 회원님의 게시물을 좋아합니다.",
            "content": "",
            "image": "",
            "time": "지난 달",
        ],
    ]
}
