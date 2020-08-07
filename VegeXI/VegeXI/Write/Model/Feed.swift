//
//  Feed.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/07.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum FeedType: String {
    case textType
    case picAndTextType
}

struct Feed {
    let feedType: FeedType
    let writerUser: User
    let writeDate: Date
    let title: String
    let content: String
    let likes: Int
    let comments: Int
    let imageUrls: [URL]?
    
    init(dictionary: [String : Any], user: User, imageUrlArray: [URL]?) {
        let type = dictionary["type"] as? String ?? "textType"
        self.feedType = FeedType(rawValue: type)!
        self.writerUser = user
        
        let timestamp = dictionary["timestamp"] as? Int ?? 0
        self.writeDate = Date(timeIntervalSince1970: TimeInterval(exactly: timestamp)!)
        
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.comments = dictionary["comments"] as? Int ?? 0
        
        switch self.feedType {
        case .textType:
            self.imageUrls = nil
        case .picAndTextType:
            self.imageUrls = imageUrlArray
        }
    }
}
