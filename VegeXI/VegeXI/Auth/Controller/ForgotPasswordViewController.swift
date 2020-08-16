//
//  ForgotPasswordViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    let viewTitle = "비밀번호 찾기"
    
    private lazy var fakeNavigationBar = FakeNavigationBar(title: viewTitle)
    
    private let infoLabel = UILabel().then {
        $0.text = SignUpStrings.passwordInfo.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.numberOfLines = 0
    }
    private let emailSignView = SignView(
        placeholder: "이메일",
        cautionType: .none,
        keyboardType: .emailAddress,
        secureEntry: false).then {
            $0.textField.becomeFirstResponder()
    }
    
    private let sendButton = SignButton(title: GeneralStrings.sendButton.generateString())
    
    
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
        [fakeNavigationBar, infoLabel, emailSignView, sendButton].forEach {
            view.addSubview($0)
        }
        
        fakeNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(fakeNavigationBar.snp.bottom)
            $0.leading.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        emailSignView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(31)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        sendButton.snp.makeConstraints {
            $0.top.equalTo(emailSignView.snp.bottom).offset(36)
            $0.leading.trailing.equalTo(emailSignView)
            $0.height.equalTo(48)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setPropertyAttributes() {
        sendButton.addTarget(self, action: #selector(handleSendButton(_:)), for: .touchUpInside)
        fakeNavigationBar.leftBarButton.addTarget(self, action: #selector(handlePopAction), for: .touchUpInside)
        
        emailSignView.textField.delegate = self
    }
    
    
    // MARK: - Helpers
    private func showWarnings(view: SignView, message: String) {
        view.underBarNeedToTurnRed = true
        view.needToShowWarning = true
        view.cautionMessageLabel.text = message
    }
    
    private func hideWarnings() {
        [emailSignView].forEach {
            $0.underBarNeedToTurnRed = false
            $0.needToShowWarning = false
        }
    }
    
    
    // MARK: - Selectors
    @objc private func handlePopAction() {
        navigationController?.popViewController(animated: true)
    }
    
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
        if textField.text?.isEmpty == true {
            sendButton.isActive = false
        } else {
            sendButton.isActive = true
        }
    }
}
