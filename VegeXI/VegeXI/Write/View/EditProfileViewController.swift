//
//  EditProfileViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    // MARK: - Properties
    private let topBarView = EditProfileTopBarView()
    private let editingView = EditProfileEditingView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setStoredPropertyAttributes()
        setConstraints()
    }
    
    private func setStoredPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleTopBarLeftBarButton(_:)), for: .touchUpInside)
        editingView.nicknameTextField.clearButton.addTarget(self, action: #selector(handleTextFieldClearButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [topBarView, editingView].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        editingView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTopBarLeftBarButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc
    private func handleTextFieldClearButton(_ sender: UIButton) {
        editingView.nicknameTextField.textField.text = ""
    }

}
