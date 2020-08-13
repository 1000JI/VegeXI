//
//  NotificationViewTopBar.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/11/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class NotificationViewTopBar: UIView {
    
    // MARK: - Properties
    private let leftAccessoryImageView = UIImageView().then {
        $0.image = UIImage(named: "naviBar_BackBtnIcon")
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    private let mainTitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
    }
    
    private let underBar = UIView().then {
        $0.backgroundColor = .vegeLightGrayBorderColor
    }
    
    
    // MARK: - Lifecycle
    init(title text: String) {
        super.init(frame: .zero)
        mainTitle.text = text
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
        [leftAccessoryImageView, mainTitle, underBar].forEach {
            addSubview($0)
        }
        leftAccessoryImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        mainTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        underBar.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
