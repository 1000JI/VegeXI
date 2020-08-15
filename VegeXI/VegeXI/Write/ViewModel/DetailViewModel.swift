//
//  DetailViewModel.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/11.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

struct DetailViewModel {
    let feed: Feed
    
    var profileImageURL: URL? {
        return feed.writerUser.profileImageUrl
    }
    
    var writeDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        return dateFormatter.string(from: feed.writeDate)
    }
    
    var likeImage: UIImage? {
        return feed.didLike ?
            UIImage(named: "feed_Heart_Fill")?
                .withRenderingMode(.alwaysOriginal) :
            UIImage(named: "feed_Heart")?
                    .withRenderingMode(.alwaysOriginal)
    }
    
    var bookmarkImage: UIImage? {
        return feed.didBookmark ?
            UIImage(named: "feed_Bookmark_Fill")?.withRenderingMode(.alwaysOriginal) :
            UIImage(named: "feed_Bookmark")?.withRenderingMode(.alwaysOriginal)
    }
}
