//
//  AppDelegate.swift
//  VegeXI
//
//  Created by 천지운 on 2020/07/31.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        snsLoginInit()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        
        if let uid = UserDefaults.standard.string(forKey: "saveUid") {
            print("DEBUG: exist uuid")
            let controller = HomeViewController()
            controller.userUid = uid
            window?.rootViewController = controller
        } else {
            print("DEBUG: not exist uuid")
            window?.rootViewController = SignInViewController()
        }
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
    
    func snsLoginInit() {
        GoogleLoginService.shared.instance?.clientID = FirebaseApp.app()?.options.clientID
        GoogleLoginService.shared.instance?.delegate = self

        NaverLoginService.shared.initNaverLogin()
    }
}

// MARK: - GIDSignInDelegate

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("DEBUG: didSignInFor Error \(error.localizedDescription)")
            return
        }
        
        GoogleLoginService.shared.registerGoogleAuth(user: user)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("DEBUG: didDisconnect \(error.localizedDescription)")
        // Perform any operations when the user disconnects from app here.
    }
}

