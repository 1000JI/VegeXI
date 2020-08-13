//
//  WriteTitleTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class WriteTitleTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "WriteTitleTableCell"
    
    var titleTextDidChange: ((UITextView) -> Void)?
    
    private let titlePlaceHolder = UILabel().then {
        $0.text = "제목을 입력해주세요"
        $0.textColor = .textViewPlaceholderTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 24)
    }
    
    private lazy var titleTextView = UITextView().then {
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 24)
        $0.isScrollEnabled = false
        $0.delegate = self
        
        $0.addSubview(titlePlaceHolder)
        titlePlaceHolder.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(6)
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
        
        let underView = UIView()
        underView.backgroundColor = .vegeLightGrayCellBorderColor
        
        [titleTextView, underView].forEach { addSubview($0) }
        titleTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-8)
        }
        underView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-1)
            $0.height.equalTo(1)
        }
    }
}


// MARK: - UITextViewDelegate

extension WriteTitleTableCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        titlePlaceHolder.isHidden = !(textView.text.isEmpty)
        titleTextDidChange?(textView)
    }
}
