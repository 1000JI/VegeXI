//
//  WriteContentTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class WriteContentTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "WriteContentTableCell"
    
    var contentTextDidChange: ((UITextView) -> Void)?
    
    private let contentPlaceHolder = UILabel().then {
        $0.text = "공유하고 싶은 내용을 입력해주세요!"
        $0.textColor = .textViewPlaceholderTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.delegate = self
        $0.isScrollEnabled = false
        
        $0.addSubview(contentPlaceHolder)
        contentPlaceHolder.snp.makeConstraints {
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
        
        [contentTextView].forEach { addSubview($0) }
        contentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}


// MARK: - UITextViewDelegate

extension WriteContentTableCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        contentPlaceHolder.isHidden = !(textView.text.isEmpty)
        contentTextDidChange?(textView)
    }
}
