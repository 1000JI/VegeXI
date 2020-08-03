//
//  AuthService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/04.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum LoginType: String {
    case kakao
    case naver
    case google
    case apple
    case basic
}

struct AuthModel {
    let email: String
    let nickname: String
    let id: String
    let imageUrl: String
    let loginType: LoginType
}

struct AuthService {
    static let shared = AuthService()
    private init() { }
    
    func registerUser(registerData: AuthModel) {
        var imageData: Data!
        do {
            imageData = try Data(contentsOf: URL(string: registerData.imageUrl)!)
        } catch {
            print("DEBUG: URL -> Data Error >", error.localizedDescription)
            return
        }
        
        guard let jpegProfileImageData = UIImage(data: imageData)?.jpegData(compressionQuality: 0.3) else { return }
        let filename = UUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(jpegProfileImageData, metadata: nil) { (meta, error) in
            if error != nil {
                print("DEBUG: Storage Save Image Data Error, \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if error != nil {
                    print("DEBUG: Storage downloadURL Error, \(error!.localizedDescription)")
                    return
                }
                
                guard let profileImageUrl = url?.absoluteString else { return }
                let uid = "\(registerData.loginType.rawValue)\(registerData.id)"
                
                let values = [
                    "email": registerData.email,
                    "nickname": registerData.nickname,
                    "profileImageUrl": profileImageUrl,
                    "type": registerData.loginType.rawValue]
                
                REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                    if let error = error {
                        print("DEBUG: Register error \(error.localizedDescription)")
                        return
                    }
                    print("DEBUG: User Register Successful")
                }
            }
        }
    }
}
