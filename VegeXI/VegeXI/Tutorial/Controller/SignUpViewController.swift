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
    lazy var textFieldStackView = UIStackView(arrangedSubviews: [idTextField, nicknameTextField, passwordTextField])
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
    lazy var buttonStackView = UIStackView(arrangedSubviews: [signUpButton, goBackButton])
    let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    let goBackButton = UIButton().then {
        $0.setTitle("돌아가기", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
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
        
    }
    
    
    // MARK: - Selectors
    @objc private func handleButtons(_ sender: UIButton) {
        switch sender {
        case signUpButton:
            print("signup")
        case goBackButton:
            print("goback")
        default:
            break
        }
    }
}

