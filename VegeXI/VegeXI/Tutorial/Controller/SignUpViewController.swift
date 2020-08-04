//
//  SignUpViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/4/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

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
        $0.backgroundColor = .lightGray
    }
    let nicknameTextField = UITextField().then {
        $0.backgroundColor = .lightGray
    }
    let passwordTextField = UITextField().then {
        $0.backgroundColor = .lightGray
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
        $0.backgroundColor = .lightGray
    }
    let goBackButton = UIButton().then {
        $0.setTitle("돌아가기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = .lightGray
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
    
    
    // MARK: - Selectors
    @objc private func handleButtons(_ sender: UIButton) {
        switch sender {
        case signUpButton:
            print("signup")
        case goBackButton:
            dismiss(animated: true)
        default:
            break
        }
    }
}

