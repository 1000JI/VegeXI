//
//  EditProfileTextField.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class EditProfileTextField: UITextField {
    
    // MARK: - Properties
    let clearButton = UIButton().then {
        let image = UIImage(named: "searchHistory_ClearButton")
        $0.setImage(image, for: .normal)
    }
    private let customPlaceholder = UILabel().then {
        $0.text = EditProfileStrings.nickname.generateString()
    }
    private let textFieldIndicator = UIView().then {
        $0.backgroundColor = .vegeLightGraySearchBarColor
    }
    
    
    // MARK: - Lifecycle
    init(placeholder text: String) {
        super.init(frame: .zero)
        customPlaceholder.text = text
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        self.font = UIFont.spoqaHanSansRegular(ofSize: 16)
        self.textColor = .vegeTextBlackColor
        self.bringSubviewToFront(clearButton)
    }
    
    private func setConstraints() {
        [customPlaceholder, textFieldIndicator, clearButton].forEach {
            self.addSubview($0)
        }
        customPlaceholder.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        textFieldIndicator.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(11.5)
            $0.bottom.equalToSuperview().offset(10)
            $0.height.equalTo(1)
        }
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
}
