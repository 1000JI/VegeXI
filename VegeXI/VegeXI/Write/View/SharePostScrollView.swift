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
    private let dismissArea = UIView().then {
        $0.backgroundColor = .clear
    }
    let sharePostContentView = SharePostContentView()
    var handleDismissAction: () -> Void = { return }
    
    
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
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        dismissArea.addGestureRecognizer(tapGesture)
        dismissArea.isUserInteractionEnabled = true
    }
    
    private func setConstraints() {
        [dismissArea, sharePostContentView].forEach {
            addSubview($0)
        }
        
        dismissArea.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(sharePostContentView.snp.bottom)
        }
        sharePostContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1200)
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTapGesture() {
        handleDismissAction()
    }
}
