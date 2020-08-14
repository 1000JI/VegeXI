//
//  SharePostScrollView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/12/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SharePostScrollView: UIScrollView {
    
    // MARK: - Properties
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let sharePostContentView = SharePostContentView()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - UI
    private func configureUI() {
//        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .clear
        blurEffectView.contentView.backgroundColor = .clear
    }
    
    private func setConstraints() {
        [/*blurEffectView,*/ sharePostContentView].forEach {
            addSubview($0)
        }
        
//        blurEffectView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(-350)
//            $0.leading.trailing.equalToSuperview()
//            $0.width.equalToSuperview()
//            $0.height.equalTo(600)
//        }
        sharePostContentView.snp.makeConstraints {
//            $0.top.equalTo(blurEffectView.snp.bottom).offset(-10)
            $0.top.equalToSuperview().offset(200)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1200)
        }
    }
    
}
