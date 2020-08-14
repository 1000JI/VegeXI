//
//  MyPagePostTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPagePostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "MyPagePostTableViewCell"
    private var feedType: FeedType = .picAndTextType
    
    private let postTitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
        $0.numberOfLines = 2
    }
    private let postSubtitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 13)
        $0.textColor = .vegeTextBlackColor
        $0.numberOfLines = 2
    }
    private let postImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    private let postingDate = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
        $0.textColor = .postGray
    }
    
    private lazy var infoStackView = UIStackView(arrangedSubviews: [likeStackView, commentStackView]).then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 25
    }
    // Likes
    private lazy var likeStackView = UIStackView(arrangedSubviews: [likeIcon, likesLabel]).then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 0
    }
    private let likeIcon = UIImageView().then {
        let image = UIImage(named: "feed_Heart_Fill")?.withTintColor(.postGray, renderingMode: .alwaysOriginal)
        $0.image = image
    }
    private let likesLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .postGray
    }
    // Comments
    private lazy var commentStackView = UIStackView(arrangedSubviews: [commentIcon, commentsLabel]).then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 0
    }
    private let commentIcon = UIImageView().then {
        let image = UIImage(named: "feed_Comment")?.withTintColor(.postGray, renderingMode: .alwaysOriginal)
        $0.image = image
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let commentsLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .postGray
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let separator = UIView().then {
        $0.backgroundColor = .vegeLightGrayCellBorderColor
    }
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        
    }
    
    private func setConstraints() {
        [postTitle, postSubtitle, postImage, postingDate, infoStackView, separator].forEach {
            self.addSubview($0)
        }
        switch feedType {
        case .picAndTextType:
            setConstraintsForPicAndTextType()
        case .textType:
            setConstraintsForTextType()
        }
        [likeIcon, commentIcon].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(20)
            }
        }
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setConstraintsForPicAndTextType() {
        postTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(postImage.snp.leading)
        }
        postSubtitle.snp.makeConstraints {
            $0.top.equalTo(postTitle.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(postImage.snp.leading)
        }
        postImage.snp.makeConstraints {
            $0.top.equalTo(postTitle)
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(94)
        }
        postingDate.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(infoStackView.snp.top)
        }
        infoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func setConstraintsForTextType() {
        postTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        postSubtitle.snp.makeConstraints {
            $0.top.equalTo(postTitle.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(postTitle)
        }
        postingDate.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(infoStackView.snp.top)
        }
        infoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    
    // MARK: - Helpers
    func configureCell(title: String, subtitle: String, image: UIImage, date: String, likes: Int, comments: Int, feedType: FeedType) {
        postTitle.text = title
        postSubtitle.text = subtitle
        postImage.image = image
        postingDate.text = date
        likesLabel.text = String(likes)
        commentsLabel.text = String(comments)
        self.feedType = feedType
    }
    
}
