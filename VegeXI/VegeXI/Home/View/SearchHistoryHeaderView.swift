//
//  SearchHistoryHeaderView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SearchHistoryHeaderView: UIView {
    
    // MARK: - Properties
    let mainTitle = UILabel().then {
        $0.text = GeneralStrings.recentSearchHistory.generateString()
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
    }
    let clearButton = UIButton().then {
        $0.setTitle(GeneralStrings.eraseAll.generateString(), for: .normal)
        $0.setTitleColor(.vegeLightGraySearchHistoryClearButtonColor, for: .normal)
        $0.titleLabel?.font = .spoqaHanSansRegular(ofSize: 12)
        $0.titleLabel?.textColor = .vegeLightGraySearchHistoryClearButtonColor
    }
    private var clearButtonActionHandler = { () -> Void in return }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
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
    
    private func setConstraints() {
        [mainTitle, clearButton].forEach {
            addSubview($0)
        }
        
        mainTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setPropertyAttributes() {
        clearButton.addTarget(self, action: #selector(handleClearButton(_:)), for: .touchUpInside)
    }
    
    
    // MARK: - Selectors
    @objc private func handleClearButton(_ sender: UIButton) {
        clearButtonActionHandler()
    }
    
    
    // MARK: - Helpers
    func configureHeader(clearButtonActionHandler: @escaping () -> Void) {
        self.clearButtonActionHandler = clearButtonActionHandler
    }
}
