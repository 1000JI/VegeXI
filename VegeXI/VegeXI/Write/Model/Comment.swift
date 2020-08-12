//
//  Comment.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/11.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

struct Comment {
    let writer: User
    let writeDate: Date
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.writer = user
        self.caption = dictionary["caption"] as? String ?? ""
        
        let timestamp = dictionary["timestamp"] as? Int ?? 0
        self.writeDate = Date(timeIntervalSince1970: TimeInterval(exactly: timestamp)!)
    }
}
