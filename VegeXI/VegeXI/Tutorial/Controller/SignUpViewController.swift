//
//  SignUpViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/4/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    // TextFields
    lazy var textFieldStackView = UIStackView(arrangedSubviews: [idTextField, nicknameTextField, passwordTextField]).then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    let idTextField = UITextField().then {
        $0.placeholder = " 아이디를 입력해주세요"
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.autocapitalizationType = .none
    }
    let nicknameTextField = UITextField().then {
        $0.placeholder = " 닉네임을 입력해주세요"
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
    lazy var buttonStackView = UIStackView(arrangedSubviews: [goBackButton, signUpButton]).then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    let goBackButton = UIButton().then {
        $0.setTitle("돌아가기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttribites()
        setConstraints()
    }
    
    private func setPropertyAttribites() {
        [signUpButton, goBackButton].forEach {
            $0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        }
    }
    
    private func setConstraints() {
        [textFieldStackView, buttonStackView].forEach {
            view.addSubview($0)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.width.equalToSuperview().offset(20)
            $0.height.equalTo(150)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-150)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(30)
        }
        
        textFieldStackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview().inset(40)
            }
        }
    }
    
    
    // MARK: - Helpers
    private func createUser() {
        guard let email = idTextField.text else { return }
        guard let nickname = nicknameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let authResult = authResult else { return print("No Auth Result") }
                let uid = authResult.user.uid
                let email = email
                let nickname = nickname
                let profileImageUrl = ""
                let type = "firebase"
                
                REF_USERS.setValue(uid)
                REF_USERS.child(uid).child("email").setValue(email)
                REF_USERS.child(uid).child("nickname").setValue(nickname)
                REF_USERS.child(uid).child("profileImageUrl").setValue(profileImageUrl)
                REF_USERS.child(uid).child("type").setValue(type)                
                self.dismiss(animated: true)
            }
        }
    }
    
    
    // MARK: - Selectors
    @objc private func handleButtons(_ sender: UIButton) {
        switch sender {
        case signUpButton:
            createUser()
        case goBackButton:
            dismiss(animated: true)
        default:
            break
        }
    }
}

