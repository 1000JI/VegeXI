//
//  EditProfileTextFieldView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class EditProfileTextFieldView: UIView {
    
    // MARK: - Properties
    let textField = UITextField().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
        $0.clipsToBounds = true
    }
    let clearButton = UIButton().then {
        let image = UIImage(named: "searchHistory_ClearButton")
        $0.setImage(image, for: .normal)
    }
    let customPlaceholder = UILabel().then {
        $0.text = ""
    }
    private let textFieldIndicator = UIView().then {
        $0.backgroundColor = .vegeLightGraySearchBarColor
    }
    private let warningLabel = UILabel().then {
        $0.text = SignErrors.nicknameAlreadyInUse.generateErrorMessage()
        $0.textColor = .vegeWarningRedColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 10)
        $0.alpha = 0
    }
    var isInvalid = false {
        willSet {
            showWarning(newValue: newValue)
        }
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    private func setConstraints() {
        [textField, clearButton, customPlaceholder, textFieldIndicator, warningLabel].forEach {
            self.addSubview($0)
        }
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(clearButton.snp.leading)
            $0.centerY.equalTo(clearButton)
            $0.height.equalTo(24)
        }
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        customPlaceholder.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        textFieldIndicator.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(11.5)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldIndicator.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
    }
    
    private func showWarning(newValue: Bool) {
        switch newValue {
        case true:
            textFieldIndicator.backgroundColor = .vegeWarningRedColor
            warningLabel.alpha = 1
        case false:
            textFieldIndicator.backgroundColor = .vegeLightGraySearchBarColor
            warningLabel.alpha = 0
        }
    }
    
}
