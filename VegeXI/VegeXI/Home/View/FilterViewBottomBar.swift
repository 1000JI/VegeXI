//
//  FilterViewBottomBar.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FilterViewBottomBar: UIView {
    
    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.text = GeneralStrings.filterBottomViewTitle.generateString()
        $0.font = UIFont.spoqaHanSansBold(ofSize: 14)
        $0.textColor = .white
    }
    var handleTapGesture: () -> Void = { () -> Void in return }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .vegeSelectedGreend
        configureUI()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setConstraints()
    }

    private func setConstraints() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
        }
    }
    
    
    // MARK: - Helpers
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureAction(_:)))
        titleLabel.addGestureRecognizer(tapGesture)
        titleLabel.isUserInteractionEnabled = true
    }
    
    func configureBottomBar(filterActionHandler: @escaping () -> Void) {
        handleTapGesture = filterActionHandler
    }
    
    
    // MARK: - Selectors
    @objc private func handleTapGestureAction(_ sender: UITapGestureRecognizer) {
        handleTapGesture()
    }
}
