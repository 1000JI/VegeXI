//
//  CategoryCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/06.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CategoryCell"
    
    let categoryLabel = UILabel().then {
        $0.text = "카테고리"
        $0.textColor = .vegeCategoryTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.textAlignment = .center
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
        backgroundColor = .white
        
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func selectCategory() {
        categoryLabel.font = UIFont.spoqaHanSansBold(ofSize: 14)
        categoryLabel.textColor = .vegeTextBlackColor
    }
    
    func deSelectCategory() {
        categoryLabel.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        categoryLabel.textColor = .vegeCategoryTextColor
    }
}
