//
//  FBSignInViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/5/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase

class FBSignInViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var textFieldStackView = UIStackView(arrangedSubviews: [idInputView, passwordInputView]).then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 15
    }
    private let idInputView = SignView(
        placeholder: "이메일",
        cautionType: .none)
    private let passwordInputView = SignView(
        placeholder: "비밀번호",
        cautionType: .unableToLogIn)
    
    private let signInButton = SignButton(title: "시작하기")
    private let forgotPasswordButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    private let signUpButton = UIButton().then {
        $0.setTitle("이메일로 가입하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setConstraints() {
        [textFieldStackView, signInButton, forgotPasswordButton, signUpButton].forEach {
            view.addSubview($0)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        textFieldStackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
        }
        signInButton.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(35)
            $0.leading.trailing.equalTo(textFieldStackView)
            $0.height.equalTo(50)
        }
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.leading.trailing.equalTo(signInButton)
            $0.height.equalTo(signInButton)
        }
    }
    
    private func setPropertyAttributes() {
        signInButton.addTarget(self, action: #selector(handleSignInButton(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUpButton(_:)), for: .touchUpInside)
        
        idInputView.textField.delegate = self
        passwordInputView.textField.delegate = self
    }
    
    
    // MARK: - Selectors
    @objc private func handleSignInButton(_ sender: UIButton) {
        guard let email = idInputView.textField.text else { return }
        guard let password = passwordInputView.textField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.generateErrorMessages(error: error)
            } else {
                print("Logged In Successfully")
            }
        }
    }
    
    @objc private func handleSignUpButton(_ sender: UIButton) {
        let nextVC = SignUpViewController()
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    
    // MARK: - Helpers
    private func generateErrorMessages(error: Error) {
        switch AuthErrorCode.init(rawValue: error._code) {
        case .invalidEmail:
            let message = SignErrors.invalidEmail.generateErrorMessage()
            showWarnings(view: idInputView, message: message)
        case .userNotFound:
            let message = SignErrors.userNotFound.generateErrorMessage()
            showWarnings(view: idInputView, message: message)
        case .wrongPassword:
            let message = SignErrors.wrongPassword.generateErrorMessage()
            showWarnings(view: passwordInputView, message: message)
        default:
            let message = SignErrors.unknown.generateErrorMessage()
            showWarnings(view: passwordInputView, message: message)
        }
    }
    
    private func showWarnings(view: SignView, message: String) {
        view.textField.alpha = 1
        view.cautionMessageLabel.text = message
    }
}


// MARK: - UITextFieldDelegate
extension FBSignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
