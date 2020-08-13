//
//  SignTextField.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/5/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SignTextField: UITextField {
    
    // MARK: - Properties
    let underBar = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    // MARK: - Lifecycle
    init(placeHolder: String?) {
        super.init(frame: .zero)
        configureUI()
        guard let placeHolder = placeHolder else { return }
        let placeholderString = NSAttributedString(string: " \(placeHolder)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.5) ])
        self.attributedPlaceholder = placeholderString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        self.autocapitalizationType = .none
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(underBar)
        underBar.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
