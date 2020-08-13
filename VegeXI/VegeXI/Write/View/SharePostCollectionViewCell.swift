//
//  SharePostCollectionViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/12/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SharePostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "SharePostCollectionViewCell"
    
    private let cellTitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 13)
        $0.textColor = .vegeTextBlackColor
    }
    
    var isClicked: Bool = false {
        willSet { configureSelectedEffects(selected: newValue) }
    }
        
    
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
        setConstraints()
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.vegeLightGrayBorderColor.cgColor
        self.layer.borderWidth = 1
    }
    
    private func setConstraints() {
        addSubview(cellTitle)
        cellTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    
    // MARK: - Helpers
    func configureCell(title: String, tag: Int) {
        self.cellTitle.text = title
        self.tag = tag
    }
    
    func configureSelectedEffects(selected: Bool) {
        self.backgroundColor = selected ? .vegeSelectedGreen : .white
        cellTitle.font = selected ? UIFont.spoqaHanSansBold(ofSize: 13) : UIFont.spoqaHanSansRegular(ofSize: 13)
        cellTitle.textColor = selected ? .white : .vegeTextBlackColor
    }
    
}
