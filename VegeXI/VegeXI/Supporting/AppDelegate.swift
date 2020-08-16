//
//  AppDelegate.swift
//  VegeXI
//
//  Created by 천지운 on 2020/07/31.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleSignIn
import NaverThirdPartyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        
        var controller: UIViewController
        if let uid = UserDefaults.standard.string(forKey: "saveUid") {
            controller = MainTabBarController()
            (controller as! MainTabBarController).userUid = uid
        } else {
            controller = SignInViewController()
        }
        window?.rootViewController = UINavigationController(rootViewController: controller)

//        let viewCon = SharePostViewController()
//        let naviCon = UINavigationController(rootViewController: viewCon)
//        window?.rootViewController = naviCon
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - Kakao, Naver Login
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Naver Login Loading
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        // Kakao Login Loading
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Kakao Login Loading
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
            return KOSession.handleOpen(url)
        }
        return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive()
    }
}

