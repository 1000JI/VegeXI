//
//  FakeNavigationBar.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FakeNavigationBar: UIView {
    
    // MARK: - Properties
    let leftBarButton = UIButton().then {
        $0.setImage(UIImage(named: "naviBar_BackBtnIcon"), for: .normal)
    }
    let mainTitle = UILabel()
    
    
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
    private func configureUI() {
        setConstraints()
    }
    
    private func setConstraints() {
        [leftBarButton, mainTitle].forEach {
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
    }
}
