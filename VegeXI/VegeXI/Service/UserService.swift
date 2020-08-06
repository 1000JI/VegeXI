//
//  UserService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/05.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

struct User {
    let email: String
    let nickname: String
    let profileImageUrl: String
    let uid: String
    let type: LoginType
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        let typeString = dictionary["type"] as? String ?? "basic"
        self.type = LoginType(rawValue: typeString)!
    }
}

final class UserService {
    static let shared = UserService()
    private init() { }
    
    var user: User?
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(User(dictionary: dictionary))
        }
    }
}
