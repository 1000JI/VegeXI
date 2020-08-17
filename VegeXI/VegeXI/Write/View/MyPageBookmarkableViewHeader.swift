//
//  MyPageBookmarkableViewHeader.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPageBookmarkableViewHeader: UIView {
    
    // MARK: - Properties
    let leftLabel = UILabel().then {
        $0.text = "글 10"
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.textColor = .vegeTextBlackColor
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
        [leftLabel].forEach {
            self.addSubview($0)
        }
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureHeader(numberOfPosts: Int) {
        leftLabel.text = "글 " + String(numberOfPosts)
    }
    
}
