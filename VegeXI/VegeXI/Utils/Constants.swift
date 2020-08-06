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

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
