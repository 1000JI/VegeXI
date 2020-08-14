//
//  MyPagePostTableViewHeader.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPagePostTableViewHeader: UIView {
    
    // MARK: - Properties
    private let leftLabel = UILabel().then {
        $0.text = "글 3"
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.textColor = .vegeTextBlackColor
    }
    
    private lazy var rightStackView = UIStackView(arrangedSubviews: [rightLabel, rightImageView]).then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 0
    }
    private let rightLabel = UILabel().then {
        $0.text = "전체"
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 13)
        $0.textColor = .vegeTextBlackColor
    }
    private let rightImageView = UIImageView().then {
        $0.clipsToBounds = true
        let image = UIImage(named: "Arrow_Down")
        $0.image = image
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
        [leftLabel, rightStackView].forEach {
            self.addSubview($0)
        }
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        rightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(18)
        }
    }
    
}