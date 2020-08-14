//
//  EditProfileEditingView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class EditProfileEditingView: UIView {
    
    // MARK: - Properties
    private let profileViewContainer = UIView()
    
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 112 / 2
        $0.backgroundColor = .red
    }
    let profileEditButton = UIButton().then {
        let image = UIImage(systemName: "camera.fill")?.withTintColor(.vegeTextBlackColor, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 32 / 2
        $0.layer.borderColor = UIColor.vegeLightGrayButtonColor.cgColor
        $0.layer.borderWidth = 0.5
    }
    
    private let nicknameLable = UILabel().then {
        $0.text = EditProfileStrings.nickname.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
    }
    let nicknameTextField = EditProfileTextFieldView()
    private let myNickname = "뚜꾸리"
    
    
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
        nicknameTextField.textField.text = myNickname
    }
    
    private func setConstraints() {
        [profileViewContainer, nicknameLable, nicknameTextField].forEach {
            self.addSubview($0)
        }
        profileViewContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(112)
        }
        nicknameLable.snp.makeConstraints {
            $0.top.equalTo(profileViewContainer.snp.bottom).offset(46)
            $0.leading.equalToSuperview().inset(20)
        }
        nicknameTextField.snp.makeConstraints {
            $0.leading.equalTo(nicknameLable.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().inset(9)
            $0.centerY.equalTo(nicknameLable)
            $0.height.equalTo(44)
        }
        
        [profileImageView, profileEditButton].forEach {
            profileViewContainer.addSubview($0)
        }
        profileImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(112)
        }
        profileEditButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.height.width.equalTo(32)
        }
    }
    
}
