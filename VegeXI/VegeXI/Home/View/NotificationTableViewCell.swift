//
//  NotificationTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/11/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "NotificationTableViewCell"
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cell_Human")
    }
    private let contentLabel = UILabel().then {
        $0.text = "이곳에 알림이 입력될 예정입니다. 이곳에 알림이 입력될 예정입니다."
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.textColor = .vegeTextBlackColor
        $0.numberOfLines = 0
    }
    private let rightAccessoryImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
    }
    private let timeInfoLabel = UILabel().then {
        $0.text = "5시간 전"
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
        $0.textColor = .vegeCommentDateColor
    }
    
    private var feedType: FeedType = .picAndTextType
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        self.selectionStyle = .none
        
    }
    
    private func setConstraints() {
        switch feedType {
        case .picAndTextType:
            setConstraintsForPicAndTextType()
        case .textType:
            setConstraintsForTextType()
        }
    }
    
    private func setConstraintsForPicAndTextType() {
        [profileImageView, contentLabel, timeInfoLabel, rightAccessoryImageView].forEach {
            addSubview($0)
        }
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(40)
            $0.width.equalTo(profileImageView.snp.height)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(rightAccessoryImageView.snp.leading).offset(-8)
        }
        rightAccessoryImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.width.equalTo(48)
            $0.height.equalTo(rightAccessoryImageView.snp.width)
            $0.trailing.equalToSuperview().inset(20)
        }
        timeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(8)
            $0.leading.equalTo(contentLabel)
        }
    }
    
    private func setConstraintsForTextType() {
        [profileImageView, contentLabel, timeInfoLabel].forEach {
            addSubview($0)
        }
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(40)
            $0.width.equalTo(profileImageView.snp.height)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
        timeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(8)
            $0.leading.equalTo(contentLabel)
        }
    }
    
    
    // MARK: - Helpers
    func configureCell(profile: String, nickname: String, system: String, content: String, image: String, time: String, type: FeedType) {
        feedType = type
        switch feedType {
        case .textType:
            profileImageView.image = profile == "" ? UIImage(named: "cell_Human") : UIImage(named: profile)
            let fullString = generateAttributedString(string1: nickname, string2: system, String3: " ", string4: content)
            contentLabel.attributedText = fullString
            timeInfoLabel.text = time
            
        case .picAndTextType:
            profileImageView.image = profile == "" ? UIImage(named: "cell_Human") : UIImage(named: profile)
            let fullString = generateAttributedString(string1: nickname, string2: system, String3: " ", string4: content)
            contentLabel.attributedText = fullString
            timeInfoLabel.text = time
            rightAccessoryImageView.image = UIImage(named: image)
        }
    }
    
    private func generateAttributedString(string1: String, string2: String, String3: String, string4: String) -> NSAttributedString {
        
        let boldFont = UIFont.spoqaHanSansBold(ofSize: 14)
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: boldFont as Any,
            .foregroundColor: UIColor.vegeTextBlackColor
        ]
        
        let font = UIFont.spoqaHanSansRegular(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor.vegeTextBlackColor
        ]
        
        let firstString = NSMutableAttributedString(string: string1, attributes: boldAttributes)
        [string2, String3, string4].forEach {
            let attributedString = NSAttributedString(string: $0, attributes: attributes)
            firstString.append(attributedString)
        }
        
        return firstString
    }
}
