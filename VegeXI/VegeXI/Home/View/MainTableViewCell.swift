//
//  MainTableViewCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/06.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MainTableViewCell"
    
    private let defaultSidePadding: CGFloat = 20
    private let buttonSize: CGFloat = 34
    
    var feed: Feed? {
        didSet { configure() }
    }
    
    // Views
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cell_Human")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        $0.layer.cornerRadius = 40 / 2
    }
    
    private let writerLabel = UILabel().then {
        $0.text = "작성자"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansBold(ofSize: 14)
    }
    
    private let writeDateLabel = UILabel().then {
        $0.text = "2020.01.01"
        $0.textColor = .vegeCategoryTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 10)
    }
    
    private let moreButton = UIButton(type: .system).then {
        let image = UIImage(named: "cell_MoreButton")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.snp.makeConstraints {
            $0.height.width.equalTo(44)
        }
    }
    
    private let moreImageCountLabel = UILabel().then {
        $0.text = "+2"
        $0.textColor = .white
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
    }
    
    private let moreCountLabelBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)
    }
    
    private lazy var feedImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.image = UIImage(named: "peed_Example")
        
        $0.addSubview(moreCountLabelBackView)
        $0.addSubview(moreImageCountLabel)
        
        moreCountLabelBackView.snp.makeConstraints {
            $0.center.equalTo(moreImageCountLabel.snp.center)
            $0.width.equalTo(moreImageCountLabel.snp.width).offset(24)
            $0.height.equalTo(moreImageCountLabel.snp.height).offset(8)
        }
        
        moreImageCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-22)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private let feedTitleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
    }
    
    private let feedContentsLabel = UILabel().then {
        $0.text = "컨텐츠 내용"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
        $0.numberOfLines = 2
    }
    
    private let heartButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "peed_Heart"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
    }
    
    private let heartCountLabel = UILabel().then {
        $0.text = "12"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 11)
    }
    
    private let commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "peed_Comment"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
    }
    
    private let commentCountLabel = UILabel().then {
        $0.text = "12"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 11)
    }
    
    private let bookmarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "peed_Bookmark_Check"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
    }
    
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moreCountLabelBackView.layer.cornerRadius = moreCountLabelBackView.frame.height / 2
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        let writeStack = UIStackView(arrangedSubviews: [
            writerLabel, writeDateLabel
        ])
        writeStack.axis = .vertical
        
        let profileStack = UIStackView(arrangedSubviews: [
            profileImageView, writeStack
        ])
        profileStack.axis = .horizontal
        profileStack.spacing = 8
        profileStack.alignment = .center
        
        
        let feedContentsStack = UIStackView(arrangedSubviews: [
            feedTitleLabel, feedContentsLabel
        ])
        feedContentsStack.axis = .vertical
        feedContentsStack.spacing = 4
        
        
        [profileStack, moreButton, feedImageView, feedContentsStack, heartButton, heartCountLabel, commentButton, commentCountLabel, bookmarkButton].forEach {
            addSubview($0)
        }
        
        profileStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(defaultSidePadding)
            $0.height.equalTo(40)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        feedImageView.snp.makeConstraints {
            $0.top.equalTo(profileStack.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(defaultSidePadding)
            $0.trailing.equalToSuperview().offset(-defaultSidePadding)
            $0.height.equalTo(324)
        }
        
        feedContentsStack.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(defaultSidePadding)
            $0.trailing.equalToSuperview().offset(-defaultSidePadding)
        }
        
        heartButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.height.equalTo(buttonSize)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(-4)
            $0.centerY.equalTo(heartButton.snp.centerY)
            $0.width.equalTo(24)
        }
        
        commentButton.snp.makeConstraints {
            $0.leading.equalTo(heartCountLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(heartButton.snp.centerY)
            $0.width.height.equalTo(buttonSize)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentButton.snp.trailing).offset(-4)
            $0.centerY.equalTo(heartButton.snp.centerY)
            $0.width.equalTo(24)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(heartButton.snp.centerY)
            $0.width.height.equalTo(buttonSize)
        }
    }
    
    func configure() {
        guard let feed = feed else { return }
        let viewModel = FeedViewModel(feed: feed)
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        writerLabel.text = feed.writerUser.nickname
        writeDateLabel.text = viewModel.writeDate
        feedTitleLabel.text = feed.title
        feedContentsLabel.text = feed.content
        heartCountLabel.text = "\(feed.likes)"
        commentCountLabel.text = "\(feed.comments)"
        
        feedImageView.sd_setImage(with: viewModel.titleFeedImageURL)
        moreImageCountLabel.text = viewModel.moreImageCount
    }
}
