//
//  MyPageProfileView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPageProfileView: UIView {
    
    // MARK: - Properties
    var userData: User? {
        didSet { configure() }
    }
    
    private let profileViewContainer = UIView()
    
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 112 / 2
        $0.image = UIImage(named: "cell_Human")
    }
    let profileEditButton = UIButton().then {
        let image = UIImage(named: "EditProfile_Icon")?.withTintColor(.vegeTextBlackColor, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 32 / 2
        $0.layer.borderColor = UIColor.vegeLightGrayButtonColor.cgColor
        $0.layer.borderWidth = 0.5
    }
    let nicknameLabel = UILabel().then {
        $0.text = MyPageStrings.unknownNickname.generateString()
        $0.font = UIFont.spoqaHanSansBold(ofSize: 20)
        $0.textColor = .vegeTextBlackColor
    }
    let vegeTypeLabel = UILabel().then {
        $0.text = MyPageStrings.unknownVegeType.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.textColor = .vegeSelectedGreen
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(user: User) {
        self.init(frame: .zero)
        self.userData = user
    }
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        
    }
    
    private func setConstraints() {
        [profileViewContainer, nicknameLabel, vegeTypeLabel].forEach {
            self.addSubview($0)
        }
        profileViewContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(112)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileViewContainer.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        vegeTypeLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
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
    
    func configure() {
        guard let user = userData else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl)
        nicknameLabel.text = user.nickname
        vegeTypeLabel.text = user.profileVegeExplainText
    }
}
