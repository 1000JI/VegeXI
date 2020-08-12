//
//  SharePostSettingSwitchView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/12/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SharePostSettingSwitchView: UIView {
    
    // MARK: - Properties
    private let shareTitle = UILabel().then {
        $0.text = SharePostStrings.setShareMode.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 17)
        $0.textColor = .vegeTextBlackColor
    }
    private let shareSwitch = UISwitch().then {
        $0.isOn = true
    }
    private let shareSubtitle = UILabel().then {
        $0.text = SharePostStrings.shareModeInfo.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 10)
        $0.textColor = .vegeLightGraySearchHistoryClearButtonColor
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
        setStoredPropertyAttributes()
        setConstraints()
    }
    
    private func setStoredPropertyAttributes() {
        shareSwitch.addTarget(self, action: #selector(handleShareSwitch(_:)), for: .valueChanged)
    }
    
    private func setConstraints() {
        [shareTitle, shareSwitch, shareSubtitle].forEach {
            self.addSubview($0)
        }
        shareTitle.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(shareSwitch)
        }
        shareSwitch.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        shareSubtitle.snp.makeConstraints {
            $0.top.equalTo(shareTitle.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleShareSwitch(_ sender: UISwitch) {
        
    }
    
}
