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
        
        print("Naver Token =>", NaverLoginService.shared.loginInstance?.accessToken)
    }
    
    // MARK: - Selectors
    
    @objc func handleLoginNaver() {
        NaverLoginService.shared.loginInstance?.delegate = self
        NaverLoginService.shared.loginInstance?.requestThirdPartyLogin()
    }
    
    @objc func clickedKakaoLogin() {
        KakaoLoginService.shared.getKakaoInfo()
    }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate

extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        print(#function)
    }
    
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        NaverLoginService.shared.getNaverInfo()
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print(#function)
        print("Token: ", NaverLoginService.shared.loginInstance?.accessToken)
    }
    
    // 로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
        print(#function)
        NaverLoginService.shared.loginInstance?.requestDeleteToken()
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
}
