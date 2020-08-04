//
//  SNSLoginService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/03.
//  Copyright © 2020 TeamSloth. All rights reserved.
//


import Foundation
import NaverThirdPartyLogin
import Alamofire

// MARK: - Naver Login Service

final class NaverLoginService {
    static let shared = NaverLoginService()
    private init() { }
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func initNaverLogin() {
        // Naver Login Loading
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        // 네이버 앱으로 인증하는 방식을 활성화
        instance?.isNaverAppOauthEnable = true
        
        // SafariViewController에서 인증하는 방식을 활성화
        instance?.isInAppOauthEnable = true
        
        // 인증 화면을 iPhone의 세로 모드에서만 사용하기
        instance?.isOnlyPortraitSupportedInIphone()
        
        // 네이버 아이디로 로그인하기 설정
        // 애플리케이션을 등록할 때 입력한 URL Scheme
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        // 애플리케이션 등록 후 발급받은 클라이언트 아이디
        instance?.consumerKey = kConsumerKey
        // 애플리케이션 등록 후 발급받은 클라이언트 시크릿
        instance?.consumerSecret = kConsumerSecret
        // 애플리케이션 이름
        instance?.appName = kServiceAppName
    }
    
    func registerNaverAuth() {
        guard let isValidAccessToken = NaverLoginService.shared.loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !isValidAccessToken { return }
        
        guard let tokenType = NaverLoginService.shared.loginInstance?.tokenType else { return }
        guard let accessToken = NaverLoginService.shared.loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            
            guard let email = object["email"] as? String else { return }
            guard let nickname = object["nickname"] as? String else { return }
            guard let id = object["id"] as? String else { return }
            guard let imageUrl = object["profile_image"] as? String else { return }
            
            let authModel = AuthModel(
                email: email,
                nickname: nickname,
                id: id,
                imageUrl: imageUrl,
                loginType: .naver)
            AuthService.shared.registerUser(registerData: authModel)
        }
    }
}


// MARK: - Kakao Login Service

final class KakaoLoginService {
    static let shared = KakaoLoginService()
    private init() { }
    
    func registerKakaoAuth() {
        guard let session = KOSession.shared() else { return }
        if session.isOpen() { session.close() }
        
//        KOSessionTask.accessTokenInfoTask { (info, error) in
//            print("TOKEN: ", error?.localizedDescription)
//        }
        
        session.open { (error) in
            if error != nil || !session.isOpen() { return }
            KOSessionTask.userMeTask(completion: { (error, user) in
                if let error = error {
                    print("DEBUG: error \(error.localizedDescription)")
                }
                
//                KOSessionTask.accessTokenInfoTask { (info, error) in
//                    print("TOKEN: ", error?.localizedDescription)
//                    print("Token: ", session.token?.accessToken)
//                }
                
                guard let user = user,
                    let email = user.account?.email,
                    let nickname = user.account?.profile?.nickname,
                    let imageUrl = user.account?.profile?.profileImageURL,
                    let id = user.id else { return }
                
                let authModel = AuthModel(
                    email: email,
                    nickname: nickname,
                    id: id,
                    imageUrl: imageUrl.absoluteString,
                    loginType: .kakao)
                
                AuthService.shared.registerUser(registerData: authModel)
            })
        }
    }
}

