//
//  DetailContentTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/14.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class DetailContentTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "DetailContentTableCell"
    
    private let buttonSize: CGFloat = 34
    
    var feed: Feed? {
        didSet { configure() }
    }
    
    var tappedLikeButton: (() -> ())?
    var tappedBookmarkButton: (() -> ())?
    
    let contentTextView = UITextView().then {
        $0.text = "컨텐츠 내용"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.isScrollEnabled = false
        $0.backgroundColor = .white
        $0.isEditable = false
    }
    
    private lazy var likeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feed_Heart"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
        $0.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
    }
    
    private let likesCountLabel = UILabel().then {
        $0.text = "12"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 11)
    }
    
    private lazy var commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feed_Comment"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
    }
    
    private let commentCountLabel = UILabel().then {
        $0.text = "12"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 11)
    }
    
    private lazy var bookmarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feed_Bookmark"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
        $0.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func buttonEvent(_ sender: UIButton) {
            switch sender {
            case likeButton:
                tappedLikeButton?()
            case bookmarkButton:
                tappedBookmarkButton?()
            default:
                break
            }
        }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        [contentTextView, likeButton, likesCountLabel, commentButton, commentCountLabel, bookmarkButton].forEach { addSubview($0) }
        contentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        likeButton.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(buttonSize)
        }
        likesCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.trailing).offset(-4)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.equalTo(24)
        }
        commentButton.snp.makeConstraints {
            $0.leading.equalTo(likesCountLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.height.equalTo(buttonSize)
        }
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentButton.snp.trailing).offset(-4)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.equalTo(24)
        }
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.height.equalTo(buttonSize)
        }
        
        let finishLineView = UIView()
        finishLineView.backgroundColor = UIColor(rgb: 0xDADBDA)
        addSubview(finishLineView)
        finishLineView.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func configure() {
        guard let feed = feed else { return }
        let viewModel = DetailViewModel(feed: feed)
        
        contentTextView.text = feed.content
        likesCountLabel.text = "\(feed.likes)"
        commentCountLabel.text = "\(feed.comments)"
        
        likeButton.setImage(viewModel.likeImage, for: .normal)
        bookmarkButton.setImage(viewModel.bookmarkImage, for: .normal)
    }
}
