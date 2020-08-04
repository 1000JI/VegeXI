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
import Then
import GoogleSignIn
import AuthenticationServices

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    // TextFields
    let idTextField = UITextField().then {
        $0.backgroundColor = .lightGray
    }
    let passwordTextField = UITextField().then {
        $0.backgroundColor = .lightGray
    }
    
    // Buttons
    let authorizationAppleIDButton = ASAuthorizationAppleIDButton()
    let googleLoginButton = GIDSignInButton()
    private lazy var kakaoLoginButton = KOLoginButton().then {
        $0.addTarget(self,
                     action: #selector(clickedKakaoLogin),
                     for: .touchUpInside)
    }
    private lazy var naverLoginButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "naver_login_short_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(handleLoginNaver), for: .touchUpInside)
    }
    let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSNSLogin()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleLoginNaver() {
        NaverLoginService.shared.loginInstance?.requestThirdPartyLogin()
    }
    
    @objc func clickedKakaoLogin() {
        KakaoLoginService.shared.registerKakaoAuth()
    }
    
    @objc private func handleAuthorizationAppleIDButton(_ sender: ASAuthorizationAppleIDButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc private func handleSignUpButton(_ sender: UIButton) {
        let nextVC = SignUpViewController()
        present(nextVC, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func configureSNSLogin() {
        authorizationAppleIDButton.addTarget(self,
                                             action: #selector(handleAuthorizationAppleIDButton(_:)),
                                             for: .touchUpInside)
        NaverLoginService.shared.loginInstance?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //        GIDSignIn.sharedInstance().signIn()
    }
    
    private func configureUI() {
        configurePropertyAttributes()
        view.backgroundColor = .systemBackground
        [idTextField, passwordTextField, authorizationAppleIDButton, googleLoginButton, naverLoginButton, kakaoLoginButton, signUpButton].forEach {
            view.addSubview($0)
        }
        
        idTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-50)
            $0.height.equalTo(45)
            $0.bottom.equalTo(passwordTextField.snp.top).offset(-25)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(idTextField)
            $0.height.equalTo(45)
            $0.bottom.equalTo(authorizationAppleIDButton.snp.top).offset(-100)
        }
        
        authorizationAppleIDButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(googleLoginButton.snp.top).offset(-16)
            $0.height.equalTo(50)
        }

        googleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(naverLoginButton.snp.top).offset(-16)
            $0.height.equalTo(50)
        }

        naverLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-16)
            $0.height.equalTo(50)
        }
     
        kakaoLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(signUpButton.snp.top).offset(-16)
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
    
    private func configurePropertyAttributes() {
        signUpButton.addTarget(self, action: #selector(handleSignUpButton(_:)), for: .touchUpInside)
    }
}


// MARK: - NaverThirdPartyLoginConnectionDelegate
extension SignInViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        print(#function)
    }
    
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        NaverLoginService.shared.registerNaverAuth()
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print(#function)
        //        print("Token: ", NaverLoginService.shared.loginInstance?.accessToken)
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


// MARK: - Sign-in with Apple Extensions
extension SignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName ?? "No Info"
            let userLastName = appleIDCredential.fullName?.familyName ?? "No Info"
            let userEmail = appleIDCredential.email ?? "No Info"
            print(userIdentifier, userFirstName, userLastName, userEmail)
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid. Show Home UI Here
                    break
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
                    break
                default: break } }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

