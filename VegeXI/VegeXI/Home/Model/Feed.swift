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

struct FeedCategory {
    let vegeType: VegeType
    let categoryTitleType: CategoryType
    let categoryType: PostCategory
    
    init(dictionary: [String: Any]) {
        let vegeString = dictionary["vegeType"] as? String ?? "nothing"
        self.vegeType = VegeType(rawValue: vegeString)!
        
        let vegeTitleString = dictionary["categoryTitleType"] as? String ?? "식단"
        self.categoryTitleType = CategoryType(rawValue: vegeTitleString)!
        
        let vegeCategoryString = dictionary["categoryType"] as? String ?? "한식"
        self.categoryType = PostCategory(rawValue: vegeCategoryString)!
    }
    
    init(vegeType: VegeType, categoryTitleType: CategoryType, categoryType: PostCategory) {
        self.vegeType = vegeType
        self.categoryTitleType = categoryTitleType
        self.categoryType = categoryType
    }
}

struct Feed {
    let feedType: FeedType
    let writerUser: User
    let feedID: String
    let writeDate: Date
    let title: String
    let content: String
    var likes: Int
    var didLike: Bool = false
    var comments: Int
    var imageUrls: [URL]?
    var location: LocationModel?
    var didBookmark: Bool = false
    var category: FeedCategory
    var isOpen: Bool
    
    init(user: User, feedID: String, dictionary: [String : Any]) {
        let type = dictionary["type"] as? String ?? "textType"
        self.feedType = FeedType(rawValue: type)!
        self.writerUser = user
        self.feedID = feedID
        
        let timestamp = dictionary["timestamp"] as? Int ?? 0
        self.writeDate = Date(timeIntervalSince1970: TimeInterval(exactly: timestamp)!)
        
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        
        self.likes = dictionary["likes"] as? Int ?? 0
        self.comments = dictionary["comments"] as? Int ?? 0
        
        if let getCategory = dictionary["category"] as? [String: Any] {
            self.category = FeedCategory(dictionary: getCategory)
        } else {
            self.category = FeedCategory(
                vegeType: .nothing,
                categoryTitleType: .diet,
                categoryType: .chineseFood)
        }
        
        self.isOpen = dictionary["isOpen"] as? Bool ?? true
    }
    
    init(dictionary: [String : Any], user: User, feedID: String, likeDidLike: Bool, bookmarkDidLike: Bool, imageUrlArray: [URL]? = nil) {
        let type = dictionary["type"] as? String ?? "textType"
        self.feedType = FeedType(rawValue: type)!
        self.writerUser = user
        self.feedID = feedID
        
        let timestamp = dictionary["timestamp"] as? Int ?? 0
        self.writeDate = Date(timeIntervalSince1970: TimeInterval(exactly: timestamp)!)
        
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        
        self.didLike = likeDidLike
        self.didBookmark = bookmarkDidLike
        self.likes = dictionary["likes"] as? Int ?? 0
        self.comments = dictionary["comments"] as? Int ?? 0
        
        switch self.feedType {
        case .textType:
            self.imageUrls = nil
        case .picAndTextType:
            self.imageUrls = imageUrlArray
        }
        
        let getLocation = dictionary["location"] as? [String: Any] ?? nil
        if let location = getLocation {
            self.location = LocationModel(dictionary: location)
        }
        
        if let getCategory = dictionary["category"] as? [String: Any] {
            self.category = FeedCategory(dictionary: getCategory)
        } else {
            self.category = FeedCategory(
                vegeType: .nothing,
                categoryTitleType: .diet,
                categoryType: .chineseFood)
        }
        
        self.isOpen = dictionary["isOpen"] as? Bool ?? true
    }
}
