//
//  ResultTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/14.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ResultTableCell"
    
    var location: LocationModel? {
        didSet { configure() }
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "상호명"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
    }
    
    private let addressLabel = UILabel().then {
        $0.text = "주소"
        $0.textColor = .textViewPlaceholderTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 11)
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        let underLine = UIView()
        underLine.backgroundColor = .vegeLightGrayForInfoView
        
        addSubview(underLine)
        underLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-1)
            $0.height.equalTo(1)
        }
    }
    
    func configure() {
        guard let location = location else { return }
        titleLabel.text = location.placeName
        addressLabel.text = location.addressName
    }
}
