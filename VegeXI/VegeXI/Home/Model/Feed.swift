//
//  Feed.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/07.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum FeedType {
    case textType
    case picAndTextType
}

struct Feed {
    let type: FeedType
    
    let writer: User
    let date: Date
    let pictrueTitleURL: URL
    let pictureCount: Int
    
    let title: String
    let content: String
    
    let heartCount: Int
    let commentCount: Int
    let isHeartMark: Bool
    let isBookMark: Bool
}
