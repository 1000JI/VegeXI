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
import Firebase

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    var firebaseStateListener: AuthStateDidChangeListenerHandle?
    
    // TextFields
    let idTextField = UITextField().then {
        $0.placeholder = " 아이디를 입력해주세요"
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.autocapitalizationType = .none
    }
    let passwordTextField = UITextField().then {
        $0.placeholder = " 패스워드를 입력해주세요"
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.autocapitalizationType = .none
        $0.isSecureTextEntry = true
    }
    
    // Buttons
    let googleLoginButton = GIDSignInButton()
    let kakaoLoginButton = KOLoginButton()
    let authorizationAppleIDButton = ASAuthorizationAppleIDButton()
    let naverLoginButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "naver_login_short_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    let signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseStateListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            print(auth, user ?? "No User")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(firebaseStateListener!)
    }
    
    
    // MARK: - Selectors
    
    @objc func handleLoginNaver() {
        NaverLoginService.shared.loginInstance?.requestThirdPartyLogin()
    }
    
    @objc func clickedKakaoLogin() {
        KakaoLoginService.shared.registerKakaoAuth()
    }
    
    @objc private func handleAuthorizationAppleIDButton(_ sender: ASAuthorizationAppleIDButton) {
        AppleLoginService.shared.appleRequestAuthorization()
    }
    
    @objc private func handleSignInButton(_ sender: UIButton) {
        guard let email = idTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Logged In Successfully")
            }
        }
    }
    
    @objc private func handleSignUpButton(_ sender: UIButton) {
                logoutMethod()
        let nextVC = SignUpViewController()
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func configureSNSLogin() {
        authorizationAppleIDButton.addTarget(self,
                                             action: #selector(handleAuthorizationAppleIDButton(_:)),
                                             for: .touchUpInside)
        kakaoLoginButton.addTarget(self,
                                   action: #selector(clickedKakaoLogin),
                                   for: .touchUpInside)
        naverLoginButton.addTarget(self,
                                   action: #selector(handleLoginNaver),
                                   for: .touchUpInside)
        
        AppleLoginService.shared.appleLoginInit(delegateView: self)
        NaverLoginService.shared.loginInstance?.delegate = self
        GoogleLoginService.shared.instance?.presentingViewController = self
    }
    
    private func configurePropertyAttributes() {
        signInButton.addTarget(self,
                               action: #selector(handleSignInButton(_:)),
                               for: .touchUpInside)
        signUpButton.addTarget(self,
                               action: #selector(handleSignUpButton(_:)),
                               for: .touchUpInside)
    }
    
    private func logoutMethod() {
        do {
            try Auth.auth().signOut()
            print("Logged Out Sucessfully")
        } catch {
            print(error)
        }
    }
    
    private func configureUI() {
        configurePropertyAttributes()
        view.backgroundColor = .systemBackground
        [idTextField, passwordTextField, signInButton, authorizationAppleIDButton, googleLoginButton, naverLoginButton, kakaoLoginButton, signUpButton].forEach {
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
            $0.bottom.equalTo(signInButton.snp.top).offset(-100)
        }
        
        signInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(idTextField)
            $0.height.equalTo(45)
            $0.bottom.equalTo(authorizationAppleIDButton.snp.top).offset(-50)
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
}


// MARK: - NaverThirdPartyLoginConnectionDelegate

extension SignInViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) { }
    
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        NaverLoginService.shared.registerNaverAuth()
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("[Success] : Success Naver Login")
        NaverLoginService.shared.registerNaverAuth()
    }
    
    // 로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
//        NaverLoginService.shared.loginInstance?.requestDeleteToken()
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
}


// MARK: - Sign-in with Apple Extensions

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        AppleLoginService.shared.registerAppleAuth(authorization: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("DEBUG: didCompleteWithError \(error.localizedDescription)")
    }
}


// MARK: - ASAuthorizationControllerPresentationContextProviding

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

