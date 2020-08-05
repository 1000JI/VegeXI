//
//  SignButton.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/5/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SignButton: UIButton {
    
    // MARK: - Properties
    var isActive = false {
        willSet {
            switch newValue {
            case true:
                self.backgroundColor = .green
            case false:
                self.backgroundColor = .lightGray
            }
        }
    }
    
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        configureUI()
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.backgroundColor = .lightGray
    }
    
    
}

