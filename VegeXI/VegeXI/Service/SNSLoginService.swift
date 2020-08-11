//
//  SNSLoginService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/03.
//  Copyright © 2020 TeamSloth. All rights reserved.
//


import Foundation
import Firebase
import FirebaseAuth
import Alamofire
import AuthenticationServices
import GoogleSignIn
import NaverThirdPartyLogin

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
            
            let authModel = AuthModel(
                email: email,
                nickname: nickname,
                uuid: id,
                loginType: .naver)
            AuthService.shared.authServiceUser(authData: authModel)
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
        session.open { (error) in
            if error != nil || !session.isOpen() {
                print("DEBUG: error \(error!.localizedDescription)")
                return
            }
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
                    let id = user.id else { return }
                
                let authModel = AuthModel(
                    email: email,
                    nickname: nickname,
                    uuid: id,
                    loginType: .kakao)
                
                AuthService.shared.authServiceUser(authData: authModel)
            })
        }
    }
}


// MARK: - AppleLoginService

final class AppleLoginService {
    static let shared = AppleLoginService()
    private init() { }
    
    private var controller: ASAuthorizationController!
    
    func appleLoginInit(delegateView: UIViewController) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = delegateView as! SignInViewController
        controller.presentationContextProvider = delegateView as! SignInViewController
    }
    
    func appleRequestAuthorization() {
        controller.performRequests()
    }
    
    func registerAppleAuth(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName ?? "No Info"
            let userLastName = appleIDCredential.fullName?.familyName ?? "No Info"
            let userEmail = appleIDCredential.email ?? "No Info"
            
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid. Show Home UI Here
//                    print("authorized")
                    break
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
//                    print("revoked")
                    break
                case .notFound:
//                    print("notFound")
                    // No credential was found. Show SignIn UI Here.
                    break
                default: break
                }
            }

            let authModel = AuthModel(
                email: userEmail,
                nickname: "\(userLastName)\(userFirstName)",
                uuid: userIdentifier,
                loginType: .apple)
            print(authModel)

            AuthService.shared.authServiceUser(authData: authModel)
        }
    }
}

final class GoogleLoginService {
    static let shared = GoogleLoginService()
    private init() { }
    
    let instance = GIDSignIn.sharedInstance()
    
    func registerGoogleAuth(user: GIDGoogleUser!) {
        guard let authentication = user.authentication else { return }
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        window.rootViewController?.showLoader(true)
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: authentication.idToken,
            accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let uuid = Auth.auth().currentUser?.uid else { return }
                guard let email = user.profile.email else { return }
                guard let name = user.profile.name else { return }
                
                let authModel = AuthModel(
                    email: email,
                    nickname: name,
                    uuid: uuid,
                    loginType: .google)
                AuthService.shared.authServiceUser(authData: authModel)
            }
        }
    }
}

final class BasicLoginService {
    static let shared = BasicLoginService()
    private init() { }
    
   
}
