//
//  FeedService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/07.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

struct FeedService {
    static let shared = FeedService()
    private init() { }
    
    func allRemoveHistories(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userUid = UserService.shared.user?.uid else { return }
        REF_USER_HISTORY.child(userUid).removeValue(completionBlock: completion)
    }
    
    func removeHistory(keyword: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userUid = UserService.shared.user?.uid else { return }
        
        REF_USER_HISTORY.child(userUid).child(keyword).removeValue(completionBlock: completion)
    }
    
    func fetchHistories(completion: @escaping([String]) -> Void) {
        guard let userUid = UserService.shared.user?.uid else { return }
        var histories = [String]()
        
        REF_USER_HISTORY.child(userUid).observeSingleEvent(of: .value) { snapshot in
            guard let values = snapshot.value as? [String: Int] else {
                completion(histories)
                return
            }
            values.keys.forEach { histories.append(String($0)) }
            completion(histories)
            return
        }
        completion(histories)
    }
    
    func uploadHistoryKeyword(keyword: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userUid = UserService.shared.user?.uid else { return }
        
        REF_USER_HISTORY.child(userUid).updateChildValues([keyword: 1], withCompletionBlock: completion)
    }
    
    func fetchMyBookmark(userUid: String, completion: @escaping([Feed]) -> Void) {
        var bookmarkFeeds = [Feed]()
        
        REF_USER_BOOKMARKS.child(userUid).observeSingleEvent(of: .value) { snapshot in
            guard let values = snapshot.value as? [String: Int] else {
                completion(bookmarkFeeds)
                return
            }
            values.keys.forEach {
                self.fetchFeed(feedID: $0) { feed in
                    bookmarkFeeds.append(feed)
                    completion(bookmarkFeeds)
                }
            }
        }
        completion(bookmarkFeeds)
    }
    
    func fetchMyFeeds(userUid: String, completion: @escaping([Feed]) -> Void) {
        var myFeeds = [Feed]()
        
        REF_USER_FEEDS.child(userUid).observeSingleEvent(of: .value) { snapshot in
            guard let values = snapshot.value as? [String: Int] else {
                completion(myFeeds)
                return
            }
            values.keys.forEach {
                self.fetchFeed(feedID: $0) { feed in
                    myFeeds.append(feed)
                    completion(myFeeds)
                }
            }
        }
        completion(myFeeds)
    }
    
    func fetchFeed(feedID: String, completion: @escaping(Feed) -> Void) {
        REF_FEEDS.child(feedID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["writerUid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                var feed = Feed(user: user, feedID: feedID, dictionary: dictionary)
                
                switch feed.feedType {
                case .textType: completion(feed)
                case .picAndTextType:
                    self.fetchFeedPictures(findKey: feedID) { urls in
                        feed.imageUrls = urls
                        completion(feed)
                    }
                }
            }
        }
    }
    
    func fetchComments(feedID: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        
        REF_FEED_COMMENTS.child(feedID)
            .observe(.childAdded,
                     with: { snapshot in
                        guard let dictionary = snapshot.value as? [String:Any],
                            let userUid = dictionary["writerUid"] as? String else { return }
                        UserService.shared.fetchUser(uid: userUid) { user in
                            let comment = Comment(user: user, dictionary: dictionary)
                            comments.append(comment)
                            completion(comments)
                        }
                        completion(comments)
            }) { error in
                print("DEBUG: ERROR \(error.localizedDescription)")
        }
        completion(comments)
    }
    
    func uploadComment(caption: String, feed: Feed, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userUid = UserService.shared.user?.uid else { return }
        
        let values = [
            "writerUid": userUid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "caption": caption
            ] as [String : Any]
        
        REF_FEED_COMMENTS
            .child(feed.feedID)
            .childByAutoId()
            .updateChildValues(values) { (error, ref) in
                if let error = error {
                    print("DEBUG: COMMENTS Upload Error \(error.localizedDescription)")
                    return
                }
                
                guard let commentID = ref.key else { return }
                REF_USER_COMMENTS
                    .child(userUid)
                    .child(feed.feedID)
                    .updateChildValues([commentID:1]) { (error, ref) in
                        if let error = error {
                            print("DEBUG: COMMENTS Upload Error \(error.localizedDescription)")
                            return
                        }
                        
                        let comments = feed.comments + 1
                        REF_FEEDS
                            .child(feed.feedID)
                            .child("comments")
                            .setValue(comments, withCompletionBlock: completion)
                }
        }
    }
    
    func checkIfUserLikedAndBookmarkFeed(feedID: String, completion: @escaping((Bool, Bool)) -> Void){
        guard let userUid = UserService.shared.user?.uid else { return }
        
        REF_USER_LIKES.child(userUid).child(feedID).observeSingleEvent(of: .value) { likeSnapshot in
            REF_USER_BOOKMARKS.child(userUid).child(feedID).observeSingleEvent(of: .value) { bookmarkSnapshot in
                completion((likeSnapshot.exists(),
                            bookmarkSnapshot.exists()))
            }
        }
    }
    
    func bookmarkFeed(feed: Feed, completion: @escaping((Error?, DatabaseReference) -> Void)) {
        guard let userUid = UserService.shared.user?.uid else { return }
        
        if feed.didBookmark {
            REF_USER_BOOKMARKS.child(userUid).child(feed.feedID).removeValue(completionBlock: completion)
        } else {
            REF_USER_BOOKMARKS.child(userUid).updateChildValues([feed.feedID:1], withCompletionBlock: completion)
        }
    }
    
    func likeFeed(feed: Feed, completion: @escaping((Error?, DatabaseReference) -> Void)) {
        guard let userUid = UserService.shared.user?.uid else { return }
        
        let likes = feed.didLike ? feed.likes - 1 : feed.likes + 1
        REF_FEEDS.child(feed.feedID).child("likes").setValue(likes)
        
        if feed.didLike {
            REF_USER_LIKES.child(userUid).child(feed.feedID).removeValue(completionBlock: completion)
        } else {
            REF_USER_LIKES.child(userUid)
                .updateChildValues([feed.feedID:1], withCompletionBlock: completion)
        }
    }
    
    func fetchFeeds(completion: @escaping([Feed]) -> Void) {
        var feeds = [Feed]()
        
        REF_FEEDS.observe(.childAdded, with: { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let userUid = dictionary["writerUid"] as? String else { return }
            guard let writeType = dictionary["type"] as? String else { return }
            let feedID = snapshot.key
            
            UserService.shared.fetchUser(uid: userUid) { user in
                self.checkIfUserLikedAndBookmarkFeed(feedID: feedID) { (likeDidLike, bookmarkDidLike) in
                    switch FeedType(rawValue: writeType)! {
                    case .textType:
                        let feed = Feed(
                            dictionary: dictionary,
                            user: user,
                            feedID: feedID,
                            likeDidLike: likeDidLike,
                            bookmarkDidLike: bookmarkDidLike)
                        feeds.append(feed)
                        feeds.sort { $0.writeDate > $1.writeDate }
                        completion(feeds)
                    case .picAndTextType:
                        self.fetchFeedPictures(findKey: snapshot.key) { urls in
                            let feed = Feed(
                                dictionary: dictionary,
                                user: user,
                                feedID: feedID,
                                likeDidLike: likeDidLike,
                                bookmarkDidLike: bookmarkDidLike,
                                imageUrlArray: urls)
                            feeds.append(feed)
                            feeds.sort { $0.writeDate > $1.writeDate }
                            completion(feeds)
                        }
                    }
                }
            }
        }) { error in
            print("DEBUG: Fetch Feeds Error \(error.localizedDescription)")
        }
    }
    
    func fetchFeedPictures(findKey: String, completion: @escaping(([URL]) -> Void)) {
        var imageUrlArray = [URL]()
        STORAGE_FEED_IMAGES.child(findKey).listAll { (result, error) in
            if let error = error {
                print("DEBUG: Image Get Error \(error.localizedDescription)")
                return
            }
            
            result.items.forEach {
                $0.downloadURL { (url, eror) in
                    guard let url = url else { return }
                    imageUrlArray.append(url)
                    
                    if result.items.count == imageUrlArray.count {
                        imageUrlArray.sort {
                            $0.absoluteString < $1.absoluteString
                        }
                        completion(imageUrlArray)
                    }
                }
            }
        }
    }
    
    func uploadFeed(title: String,
                    content: String,
                    imageArray: [UIImage],
                    location: LocationModel? = nil,
                    category: FeedCategory,
                    isOpen: Bool,
                    completion: @escaping((Error?, DatabaseReference) -> Void)) {
        guard let writerUid = UserService.shared.user?.uid else { return }
        
        let feedType = imageArray.count > 0 ?
            FeedType.picAndTextType: FeedType.textType
        
        let categoryValue = [
            "vegeType": category.vegeType.rawValue,
            "categoryTitleType": category.categoryTitleType.rawValue,
            "categoryType": category.categoryType.rawValue
        ]
        
        var values = [
            "writerUid": writerUid,
            "type": feedType.rawValue,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "title": title,
            "content": content,
            "likes": 0,
            "comments": 0,
            "category": categoryValue,
            "isOpen": isOpen
            ] as [String : Any]
        
        if let location = location {
            var locationValue = [
                "place_name": location.placeName,
                "address_name": location.addressName,
                "road_address_name": location.roadAddressName,
                "x": String(location.longitude),
                "y": String(location.latitude),
                "id": String(location.id)
                ] as [String : Any]
            
            if let url = location.placeUrl {
                locationValue.updateValue(url.absoluteString, forKey: "place_url")
            }
            values.updateValue(locationValue, forKey: "location")
        }
        
        REF_FEEDS.childByAutoId().updateChildValues(values) { (error, ref) in
            if let error = error {
                debugPrint("DEBUG: Feed Upload error \(error.localizedDescription)")
            }
            
            guard let feedID = ref.key else { return }
            REF_USER_FEEDS.child(writerUid).updateChildValues([feedID:1], withCompletionBlock: completion)
            
            switch feedType {
            case .textType: break
            case .picAndTextType:
                imageArray.enumerated().forEach {
                    guard let jpegProfileImageData = $1.jpegData(compressionQuality: 0.3) else { return }
                    STORAGE_FEED_IMAGES.child(feedID).child("picture\($0)").putData(jpegProfileImageData, metadata: nil) { (meta, error) in
                        if let error = error {
                            debugPrint("DEBUG: Image Upload Error \(error.localizedDescription)")
                            return
                        }
                        print("DEBUG: Image Upload Success")
                    }
                }
            }
        }
    }
}
