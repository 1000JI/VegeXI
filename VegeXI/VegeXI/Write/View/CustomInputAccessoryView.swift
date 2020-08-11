//
//  CustomInputAccessoryView.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/10.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class CustomInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cell_Human")
        $0.snp.makeConstraints {
            $0.height.width.equalTo(38)
        }
    }
    
    private let commentTextField = UITextField().then {
        $0.placeholder = "댓글 달기"
        $0.layer.borderColor = UIColor.vegeLightGrayBorderColor.cgColor
        $0.layer.borderWidth = 1
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.rightView = paddingView
        $0.rightViewMode = .always
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
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
        // https://zeddios.tistory.com/474
        autoresizingMask = .flexibleHeight
        
        layer.borderColor = UIColor.vegeLightGrayBorderColor.cgColor
        layer.borderWidth = 0.5
        backgroundColor = .white
        
        [profileImageView, commentTextField].forEach {
            addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(12)
        }
        commentTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        commentTextField.layer.cornerRadius = 40 / 2
    }
}
