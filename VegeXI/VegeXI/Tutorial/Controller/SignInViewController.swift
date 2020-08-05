//
//  ViewController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/07/31.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Alamofire
import AuthenticationServices
import Firebase
import FirebaseAuth
import GoogleSignIn
import KakaoOpenSDK
import NaverThirdPartyLogin
import SnapKit
import Then
import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "slowvegexicon")
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints {
            $0.height.width.equalTo(150)
        }
    }
    
    private lazy var logoView = UIView().then {
        $0.backgroundColor = .clear
        $0.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSNSLogin()
    }
    
    // MARK: - Selectors
    
    @objc func emailSignEvent(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Email SignIn")
        case 1:
            print("Email SignUp")
        default:
            break
        }
    }
    
    @objc func snsLoginEvent(_ sender: UITapGestureRecognizer) {
        guard let tagValue = sender.view?.tag else { return }
        
        switch tagValue {
        case 0: // kakao
            KakaoLoginService.shared.registerKakaoAuth()
        case 1: // naver
            NaverLoginService.shared.loginInstance?.requestThirdPartyLogin()
        case 2: // google
            GoogleLoginService.shared.instance?.signIn()
        case 3: // apple
            AppleLoginService.shared.appleRequestAuthorization()
        default:
            break
        }
    }
    
    @objc private func handleSignInButton(_ sender: UIButton) {
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Logged In Successfully")
//            }
//        }
    }
    
    @objc private func handleSignUpButton(_ sender: UIButton) {
        logoutMethod()
        let nextVC = SignUpViewController()
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func configureSNSLogin() {
        AppleLoginService.shared.appleLoginInit(delegateView: self)
        NaverLoginService.shared.loginInstance?.delegate = self
        GoogleLoginService.shared.instance?.presentingViewController = self
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
        view.backgroundColor = .systemBackground
        
        let snsButtonStack = UIStackView(arrangedSubviews: [
            makeSnsSignInButton(imageName: "kakaoicon",
                                withText: "카카오톡으로 시작하기",
                                tag: 0),
            makeSnsSignInButton(imageName: "navericon",
                                withText: "네이버로 시작하기",
                                tag: 1),
            makeSnsSignInButton(imageName: "googleicon",
                                withText: "Google로 시작하기",
                                tag: 2),
            makeSnsSignInButton(imageName: "appleicon",
                                withText: "Apple로 시작하기",
                                tag: 3)
        ])
        snsButtonStack.axis = .vertical
        snsButtonStack.spacing = 14
        
        
        let lineView = UIView()
        lineView.backgroundColor = .vegeTextBlackColor
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(11)
        }
        
        let emailStack = UIStackView(arrangedSubviews: [
            makeEmailButton(title: "이메일로 시작하기", tag: 0),
            lineView,
            makeEmailButton(title: "이메일로 가입하기", tag: 1)
        ])
        emailStack.axis = .horizontal
        emailStack.spacing = 20
        
        view.addSubview(logoView)
        view.addSubview(snsButtonStack)
        view.addSubview(emailStack)
        
        // Layout
        
        logoView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(snsButtonStack.snp.top)
        }
        
        snsButtonStack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(emailStack.snp.top).offset(-20)
        }
        
        emailStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }
    }
    
    func makeEmailButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.vegeTextBlackColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(emailSignEvent), for: .touchUpInside)
        button.tag = tag
        return button
    }
    
    func makeSnsSignInButton(imageName: String, withText: String, tag: Int) -> UIView {
        let view = UIView()
        let snsImageView = UIImageView()
        let snsLabel = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(snsLoginEvent))
        
        view.addSubview(snsLabel)
        view.addSubview(snsImageView)
        view.addGestureRecognizer(tapGesture)
        
        
        view.tag = tag
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        snsImageView.image = UIImage(named: imageName)
        snsImageView.contentMode = .scaleAspectFill
        
        snsLabel.text = withText
        snsLabel.textColor = .vegeTextBlackColor
        snsLabel.textAlignment = .center
        snsLabel.font = .systemFont(ofSize: 12)
        snsLabel.layer.borderColor = UIColor.vegeLightGrayBorderColor.cgColor
        snsLabel.layer.borderWidth = 0.5
        
        view.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        snsImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(snsImageView.snp.height)
        }
        
        snsLabel.snp.makeConstraints {
            $0.leading.equalTo(snsImageView.snp.trailing).offset(-0.5)
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        return view
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

