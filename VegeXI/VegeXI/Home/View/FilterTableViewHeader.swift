//
//  FilterTableViewHeader.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FilterTableViewHeader: UIView {
    
    // MARK: - Properties
    let leftLabel = UILabel().then {
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
    }
    let underBar = UIView().then {
        $0.backgroundColor = .vegeLightGrayBorderColor
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setConstraints()
    }
    
    private func setConstraints() {
        [leftLabel, underBar].forEach {
            addSubview($0)
        }
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.bottom.equalTo(underBar.snp.top).offset(-10)
        }
        underBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    
    // MARK: - Helpers
    func configureHeader(text: String) {
        leftLabel.text = text
    }
}
