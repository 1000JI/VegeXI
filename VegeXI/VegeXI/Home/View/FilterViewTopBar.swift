//
//  FilterViewTopBar.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FilterViewTopBar: UIView {
    
    // MARK: - Properties
    let titleLabel = UILabel().then {
        $0.text = GeneralStrings.filterViewTitle.generateString()
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
    }
    let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "filterView_CloseButton"), for: .normal)
    }
    var closeButtonHandler: () -> Void = { return }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
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
        closeButton.addTarget(self, action: #selector(handleClearButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [titleLabel, closeButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    func configureTopBar(closeFilterAction: @escaping () -> Void) {
        closeButtonHandler = closeFilterAction
    }
    
    
    // MARK: - Selectors
    @objc private func handleClearButton(_ sender: UIButton) {
        closeButtonHandler()
    }
    
}
