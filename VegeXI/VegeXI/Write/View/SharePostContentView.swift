//
//  SharePostContentView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/12/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SharePostContentView: UIView {
    
    // MARK: - Properties
    private let topIndicatorBar = UIView().then {
        $0.backgroundColor = .vegeLightGrayBorderColor
        $0.layer.cornerRadius = 10
    }
    let vegeTypeInfoView = SharePostVegeTypeView().then {
        $0.tag = 0
    }
    private let categoryLabel = UILabel().then {
        $0.text = SharePostStrings.category.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 17)
        $0.textColor = .vegeTextBlackColor
    }
    var categoryViews = [SharePostCategoryView]()
    private let data = MockData.newFilteredList
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
        self.layer.cornerRadius = 10
    }
    
    private func setConstraints() {
        [topIndicatorBar, vegeTypeInfoView, categoryLabel].forEach {
            addSubview($0)
        }
        topIndicatorBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(4)
        }
        
        vegeTypeInfoView.snp.makeConstraints {
            $0.top.equalTo(topIndicatorBar.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(350)
        }
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(vegeTypeInfoView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        generateCategoryViews()
    }
    
    private func generateCategoryViews() {
        let count = data.count
        for index in 1..<count {
            guard let title = data[index].keys.first, let data = self.data[index][title] else { return }
            let isFolded = index == 1 ? false : true
            let view = SharePostCategoryView(title: title, isFolded: isFolded, data: data).then {
                $0.tag = index
            }
            self.addSubview(view)
            if categoryViews.count == 0 {
                view.snp.makeConstraints {
                    $0.top.equalTo(categoryLabel.snp.bottom).offset(12)
                    $0.leading.trailing.equalToSuperview().inset(20)
                    $0.height.equalTo(130)
                }
            } else {
                view.snp.makeConstraints {
                    $0.top.equalTo(categoryViews.last!.snp.bottom).offset(12)
                    $0.leading.trailing.equalToSuperview().inset(20)
                    $0.height.equalTo(130)
                }
            }
            categoryViews.append(view)
        }
    }
    
}
