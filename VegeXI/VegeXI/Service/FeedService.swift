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

struct FeedService {
    static let shared = FeedService()
    private init() { }
    
    func fetchFeeds(completion: @escaping([Feed]) -> Void) {
        var feeds = [Feed]()
        
        REF_FEEDS.observe(.childAdded, with: { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let userUid = dictionary["writerUid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: userUid) { user in
                self.fetchFeedPictures(findKey: snapshot.key) { urls in
                    let feed = Feed(dictionary: dictionary, user: user, imageUrlArray: urls)
                    feeds.append(feed)
                    completion(feeds)
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
            }
            
            result.items.forEach {
                $0.downloadURL { (url, eror) in
                    guard let url = url else { return }
                    imageUrlArray.append(url)
                    
                    if result.items.count == imageUrlArray.count {
                        completion(imageUrlArray)
                    }
                }
            }
        }
    }
    
    func uploadFeed(title: String, content: String, imageArray: [UIImage], completion: @escaping((Error?, DatabaseReference) -> Void)) {
        guard let writerUid = UserService.shared.user?.uid else { return }
        
        let feedType = imageArray.count >= 0 ?
            FeedType.picAndTextType: FeedType.textType
        
        let values = [
            "writerUid": writerUid,
            "type": feedType.rawValue,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "title": title,
            "content": content,
            "likes": 0,
            "comments": 0
            ] as [String : Any]
        
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
                    print($0, $1)
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
