//
//  Constants.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/03.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Firebase
import FirebaseDatabase
import FirebaseStorage

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let STORAGE_FEED_IMAGES = STORAGE_REF.child("feed_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_USER_FEEDS = DB_REF.child("user-feeds")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_USER_BOOKMARKS = DB_REF.child("user-bookmarks")
let REF_USER_COMMENTS = DB_REF.child("user-comments")

let REF_FEEDS = DB_REF.child("feeds")
let REF_FEED_COMMENTS = DB_REF.child("feed-comments")
