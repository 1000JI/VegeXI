//
//  FeedViewModel.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/08.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

struct FeedViewModel {
    let feed: Feed
    
    var profileImageURL: URL? {
        return URL(string: feed.writerUser.profileImageUrl)
    }
    
    var titleFeedImageURL: URL? {
        switch feed.feedType {
        case .textType: return nil
        case .picAndTextType: return feed.imageUrls?.first
        }
    }
    
    var moreImageCount: String {
        guard let imageURLs = feed.imageUrls else { return "0"}
        return "+\(imageURLs.count - 1)"
    }
    
    var moreLabelIsHidden: Bool {
        guard let imageURLs = feed.imageUrls else { return true}
        return imageURLs.count > 1 ? false : true
    }
    
    var writeDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        return dateFormatter.string(from: feed.writeDate)
    }
}
