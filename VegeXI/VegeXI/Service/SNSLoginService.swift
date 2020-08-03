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
    
    func getNaverInfo() {
        guard let isValidAccessToken = NaverLoginService.shared.loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !isValidAccessToken {
            return
        }
        guard let tokenType = NaverLoginService.shared.loginInstance?.tokenType else { return }
        guard let accessToken = NaverLoginService.shared.loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            print(object)
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            guard let nickname = object["nickname"] as? String else { return }
            
            print(name, email, nickname)
        }
    }
}


// MARK: - Kakao Login Service

final class KakaoLoginService {
    static let shared = KakaoLoginService()
    private init() { }
    
    func getKakaoInfo() {
        guard let session = KOSession.shared() else { return }
        if session.isOpen() { session.close() }
        
//        KOSessionTask.accessTokenInfoTask { (info, error) in
//            print("TOKEN: ", error?.localizedDescription)
//        }
        
        session.open { (error) in
            print("session error ", error.debugDescription)
            if error != nil || !session.isOpen() { return }
            KOSessionTask.userMeTask(completion: { (error, user) in
                KOSessionTask.accessTokenInfoTask { (info, error) in
                    print("TOKEN: ", error?.localizedDescription)
                }
                print("Token: ", session.token?.accessToken)
                print("error \(error.debugDescription)")
                print("user: ", user)
                guard let user = user,
                    let email = user.account?.email,
                    let nickname = user.account?.profile?.nickname else { return }
                
                print(email, nickname)
            })
        }
    }
}

