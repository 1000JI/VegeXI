//
//  WriteNavigationBar.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class WriteNavigationBar: UIView {
    
    // MARK: - Properties
    private let leftBarButton = UIButton().then {
        $0.setImage(UIImage(named: "naviBar_BackBtnIcon"), for: .normal)
    }
    private let mainTitle = UILabel().then {
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
    }
    private let writeBarButton = UIButton(type: .system).then {
        $0.setTitle("공유", for: .normal)
        $0.setTitleColor(.buttonDisabledTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.isEnabled = false
    }
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        configureUI()
        mainTitle.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func enabledWriteFeed(isEnabled: Bool) {
        if isEnabled {
            writeBarButton.setTitleColor(.buttonEnabledTextcolor, for: .normal)
            writeBarButton.isEnabled = true
        } else {
            writeBarButton.setTitleColor(.buttonDisabledTextColor, for: .normal)
            writeBarButton.isEnabled = false
        }
    }
    
    private func configureUI() {
        setConstraints()
    }
    
    private func setConstraints() {
        [leftBarButton, mainTitle, writeBarButton].forEach {
            addSubview($0)
        }
        
        leftBarButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        writeBarButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
