//
//  DetailTitleTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/14.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class DetailTitleTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "DetailTitleTableCell"
    
    let titleTextView = UITextView().then {
        $0.text = "타이틀 제목"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.isScrollEnabled = false
        $0.isEditable = false
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
        
        addSubview(titleTextView)
        titleTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
