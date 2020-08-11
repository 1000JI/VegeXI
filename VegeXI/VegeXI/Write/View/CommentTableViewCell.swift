//
//  CommentTableViewCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/10.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CommentTableViewCell"
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage.basicHumanImage
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints {
            $0.height.width.equalTo(24)
        }
    }
    
    private let writerNameLabel = UILabel().then {
        $0.font = UIFont.spoqaHanSansBold(ofSize: 11)
        $0.text = "작성자"
        $0.textColor = .vegeTextBlackColor
    }
    
    private let commentLabel = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
        $0.numberOfLines = 0
        $0.text = "댓글 내용"
        $0.textColor = .vegeTextBlackColor
    }
    
    private let writeDateLabel = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 10)
        $0.text = "2020.08.07 3:32PM"
        $0.textColor = .vegeCommentDateColor
    }
    
    lazy var commentStack = UIStackView(
        arrangedSubviews: [
            writerNameLabel, commentLabel, writeDateLabel]).then {
                $0.axis = .vertical
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        [profileImageView, commentStack].forEach {
            addSubview($0)
        }
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        commentStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
}
