//
//  SignView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/5/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SignView: UIView {
    
    // MARK: - Properties
    let textField = UITextField().then {
        $0.autocapitalizationType = .none
        $0.clearButtonMode = .whileEditing
    }
    let underBar = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let cautionMessageLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.alpha = 0
    }
    
    
    // MARK: - Lifecycle
    init(placeholder: String?, cautionType: SignErrors?, keyboardType: UIKeyboardType, secureEntry: Bool) {
        super.init(frame: .zero)
        configureUI()
        
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = secureEntry
        
        guard let placeholder = placeholder else { return }
        let placeholderString = NSAttributedString(string: "  \(placeholder)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.5) ])
        textField.attributedPlaceholder = placeholderString
        
        guard let cautionType = cautionType else { return }
        cautionMessageLabel.text = "  \(cautionType.generateErrorMessage())"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setConstraints()
    }
    
    private func setConstraints() {
        [textField, underBar, cautionMessageLabel].forEach {
            addSubview($0)
        }
        textField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        underBar.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        cautionMessageLabel.snp.makeConstraints {
            $0.top.equalTo(underBar.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(textField)
        }
    }
}
