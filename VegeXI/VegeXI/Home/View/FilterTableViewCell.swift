//
//  FilterTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FilterTableViewCell"
    
    let leftLabel = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 15)
        $0.textColor = .vegeTextBlackColor
    }
    let rightAccessoryImageView = UIImageView().then {
        $0.image = UIImage(named: "filterView_CheckMark")
    }
    override var isSelected: Bool {
        willSet {
            handleDidSelected(selected: newValue)
        }
    }
    
    
    // MARK: - UI
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setContraints()
    }
    
    private func setContraints() {
        [leftLabel, rightAccessoryImageView].forEach {
            addSubview($0)
        }
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(34)
            $0.centerY.equalToSuperview()
        }
        rightAccessoryImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    // MARK: - Methods
    func handleDidSelected(selected: Bool) {
        leftLabel.textColor = selected ? .vegeSelectedGreend : .vegeTextBlackColor
        leftLabel.font = selected ? UIFont.spoqaHanSansBold(ofSize: 15) : UIFont.spoqaHanSansRegular(ofSize: 15)
        rightAccessoryImageView.alpha = selected ? 1 : 0
    }
    
    
    // MARK: - Helpers
    func configureCell(text: String) {
        leftLabel.text = text
    }
}

