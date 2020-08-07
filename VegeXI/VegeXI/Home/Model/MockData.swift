//
//  MockData.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

struct MockData {
    
    static var searchHistory = ["레시피", "이지호립밤", "주방세제"]
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
}
