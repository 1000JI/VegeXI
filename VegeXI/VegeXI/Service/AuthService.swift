//
//  AuthService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/04.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

struct AuthModel {
    let email: String
    let nickname: String
    let uuid: String
    let loginType: LoginType
}

struct AuthService {
    static let shared = AuthService()
    private init() { }
    
    func authServiceUser(authData: AuthModel) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        window.rootViewController?.showLoader(true)
        
        guard let jpegProfileImageData = UIImage(named: "slowvegexicon")?.jpegData(compressionQuality: 0.3) else { return }
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
                
                var uid: String
                switch authData.loginType {
                case .kakao: fallthrough
                case .naver: uid = "\(authData.loginType.rawValue)\(authData.uuid)"
                case .google: fallthrough
                case .apple: fallthrough
                case .basic: uid = authData.uuid
                }
                
                self.saveUserDefaultUID(withUid: uid)
                REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                    guard var dictionary = snapshot.value as? [String: Any] else {
                        print("DEBUG: No User")
                        
                        let values = [
                            "email": authData.email,
                            "nickname": authData.nickname,
                            "profileImageUrl": profileImageUrl,
                            "uid": uid,
                            "type": authData.loginType.rawValue,
                            "vegeType": "nothing"]
                        
                        REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                            if let error = error {
                                print("DEBUG: Register error \(error.localizedDescription)")
                                return
                            }
                            print("DEBUG: User Register Successful")
                            UserService.shared.user = User(dictionary: values)
                            self.rootHomeViewSetupVisible()
                        }
                        return
                    }
                    print("DEBUG: Find User ", dictionary)
                    dictionary.updateValue(uid, forKey: "uid")
                    UserService.shared.user = User(dictionary: dictionary)
                    self.rootHomeViewSetupVisible()
                }
            }
        }
    }
    
    func saveUserDefaultUID(withUid: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(withUid, forKey: "saveUid")
    }
    

    
    func rootHomeViewSetupVisible() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        window.rootViewController?.showLoader(false)
        window.rootViewController = MainTabBarController()
        window.frame = UIScreen.main.bounds
        window.makeKeyAndVisible()
    }
}
