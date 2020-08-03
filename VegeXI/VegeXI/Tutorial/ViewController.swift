//
//  ViewController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/07/31.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import SnapKit
import KakaoOpenSDK
import NaverThirdPartyLogin
import Alamofire

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private lazy var loginButton: KOLoginButton = {
        let button = KOLoginButton()
        button.addTarget(self, action: #selector(clickedKakaoLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var naverLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "naver_login_short_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handleLoginNaver), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        view.addSubview(naverLoginButton)
        naverLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(loginButton.snp.top).offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleLoginNaver() {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    @objc func clickedKakaoLogin() {
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
    
    // MARK: - Helpers
    
    private func getNaverInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !isValidAccessToken {
            return
        }
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
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

extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        print(#function)
    }
    
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        getNaverInfo()
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print(#function)
    }
    
    // 로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
        print(#function)
        loginInstance?.requestDeleteToken()
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
}
