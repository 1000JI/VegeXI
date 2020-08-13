//
//  MyPageTopBarView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPageTopBarView: UIView {
    
    // MARK: - Properties
    private let barTitle = UILabel().then {
        $0.text = MyPageStrings.barTitle.generateString()
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
    }
    let rightBarButton = UIButton().then {
        let image = UIImage(named: "Setting_Icon")?.withTintColor(.vegeTextBlackColor, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
    }
    private let separator = UIView().then {
        $0.backgroundColor = .vegeLightGrayButtonColor
    }
    
    
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
        
    }
    
    private func setConstraints() {
        [barTitle, rightBarButton, separator].forEach {
            self.addSubview($0)
        }
        barTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        rightBarButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        separator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
}
