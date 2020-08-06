//
//  ForgotPasswordViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    let emailSignView = SignView(
        placeholder: "이메일",
        cautionType: .none,
        keyboardType: .emailAddress,
        secureEntry: false)
    
    let sendButton = SignButton(title: GeneralStrings.sendButton.generateString())
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setConstraints()
        setPropertyAttributes()
    }
    
    private func setConstraints() {
        [emailSignView, sendButton].forEach {
            view.addSubview($0)
        }
        
        emailSignView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(70)
            $0.centerX.equalToSuperview()
        }
        sendButton.snp.makeConstraints {
            $0.top.equalTo(emailSignView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(emailSignView)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setPropertyAttributes() {
        sendButton.addTarget(self, action: #selector(handleSendButton(_:)), for: .touchUpInside)
        
        emailSignView.textField.delegate = self
    }
    
    
    // MARK: - Helpers
    private func showWarnings(view: SignView, message: String) {
        view.underBar.backgroundColor = .red
        view.cautionMessageLabel.alpha = 1
        view.cautionMessageLabel.text = message
    }
    
    private func hideWarnings() {
        [emailSignView].forEach {
            $0.underBar.backgroundColor = .lightGray
            $0.cautionMessageLabel.alpha = 0
        }
    }
    
    
    // MARK: - Selectors
    @objc private func handleSendButton(_ sender: UIButton) {
        guard let email = emailSignView.textField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                switch AuthErrorCode(rawValue: error._code) {
                case .missingEmail:
                    let message = SignErrors.missingEmail.generateErrorMessage()
                    self.showWarnings(view: self.emailSignView, message: message)
                case .invalidEmail:
                    let message = SignErrors.invalidEmail.generateErrorMessage()
                    self.showWarnings(view: self.emailSignView, message: message)
                case .userNotFound:
                    let message = SignErrors.userNotFound.generateErrorMessage()
                    self.showWarnings(view: self.emailSignView, message: message)
                default:
                    let message = SignErrors.unknown.generateErrorMessage()
                    self.showWarnings(view: self.emailSignView, message: message)
                }
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        hideWarnings()
    }
}
