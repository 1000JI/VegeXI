//
//  WriteMapTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class WriteMapTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "WriteMapTableCell"
    
    private let locationIcon = UIImageView().then {
        $0.image = UIImage(named: "write_Location_Green_Icon")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "위치"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 13)
    }
    
    private let deleteIcon = UIImageView().then {
        $0.image = UIImage(named: "write_Close_LightGray")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
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
        backgroundColor = .white
        [locationIcon, locationLabel, deleteIcon].forEach {
            addSubview($0)
        }
        
        locationIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIcon.snp.trailing).offset(-4)
            $0.centerY.equalToSuperview()
        }
        
        deleteIcon.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.trailing).offset(-4)
            $0.centerY.equalToSuperview()
        }
    }
}
