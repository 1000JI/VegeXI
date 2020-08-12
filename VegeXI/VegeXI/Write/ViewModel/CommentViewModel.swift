//
//  CommentViewModel.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/11.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

struct CommentViewModel {
    let comment: Comment
    
    var profileImageURL: URL? {
        return URL(string: comment.writer.profileImageUrl)
    }
    
    var writeDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd h:m a"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        return dateFormatter.string(from: comment.writeDate)
    }
    
    var writerName: String {
        return comment.writer.nickname
    }
}
