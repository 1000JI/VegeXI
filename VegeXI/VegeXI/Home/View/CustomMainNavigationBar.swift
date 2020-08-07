//
//  CustomMainNavigationBar.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/06.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class CustomMainNavigationBar: UIView {
    
    // MARK: - Properties
    
    private let naviTitleLabel = UILabel().then {
        $0.text = "느린채식"
        $0.font = UIFont.spoqaHanSansBold(ofSize: 24)
        $0.textAlignment = .left
    }
    
    private lazy var searchButton = makeButton(imageName: "naviBar_SearchBtnIcon")
    private lazy var alertButton = makeButton(imageName: "naviBar_AlertBtnIcon")
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(naviTitleLabel)
        
        naviTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        let buttonStack = UIStackView(arrangedSubviews: [searchButton, alertButton])
        buttonStack.axis = .horizontal
        
        addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        
    }
    
    func makeButton(imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .black
        button.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        return button
    }
    
}
