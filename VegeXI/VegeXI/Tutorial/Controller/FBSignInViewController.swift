//
//  FBSignInViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/5/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FBSignInViewController: UIViewController {
    
    // MARK: - Properties
    private let viewTitle = "로그인"
    
    private lazy var fakeNavigationBar = FakeNavigationBar(title: viewTitle)
    private lazy var textFieldStackView = UIStackView(arrangedSubviews: [idInputView, passwordInputView]).then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 25
    }
    private let idInputView = SignView(
        placeholder: SignInStrings.email.generateString(),
        cautionType: .none,
        keyboardType: .emailAddress,
        secureEntry: false
    )
    private let passwordInputView = SignView(
        placeholder: SignInStrings.password.generateString(),
        cautionType: .none,
        keyboardType: .default,
        secureEntry: true
    )
    private let signInButton = SignButton(title: GeneralStrings.startButton.generateString())
    private let forgotPasswordButton = UIButton().then {
        $0.setTitle(GeneralStrings.findPassword.generateString(), for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    private let signUpButton = UIButton().then {
        $0.setTitle(GeneralStrings.signupWithEmail.generateString(), for: .normal)
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
        hideKeyboardWhenTappedAround()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        view.backgroundColor = .white
        
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setConstraints() {
        [fakeNavigationBar, textFieldStackView, signInButton, forgotPasswordButton, signUpButton].forEach {
            view.addSubview($0)
        }
        
        fakeNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(fakeNavigationBar.snp.bottom)
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
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPasswordButton(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUpButton(_:)), for: .touchUpInside)
        fakeNavigationBar.leftBarButton.addTarget(self, action: #selector(handlePopAction), for: .touchUpInside)
        
        idInputView.textField.becomeFirstResponder()
        idInputView.textField.delegate = self
        passwordInputView.textField.delegate = self
    }
    
    
    // MARK: - Selectors
    @objc private func handlePopAction() {
        navigationController?.popViewController(animated: true)
    }
    
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
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func handleForgotPasswordButton(_ sender: UIButton) {
        let nextVC = ForgotPasswordViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    // MARK: - Helpers
    private func generateErrorMessages(error: Error) {
        switch AuthErrorCode(rawValue: error._code) {
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
        view.cautionMessageLabel.alpha = 1
        view.cautionMessageLabel.text = message
    }
    
    private func hideWarnings() {
        [idInputView, passwordInputView].forEach {
            $0.cautionMessageLabel.alpha = 0
        }
    }
}


// MARK: - UITextFieldDelegate
extension FBSignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if idInputView.textField.text != "" && passwordInputView.textField.text != "" {
            signInButton.isActive = true
        } else {
            signInButton.isActive = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideWarnings()
        return true
    }
}

