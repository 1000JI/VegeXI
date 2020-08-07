//
//  SearchHistoryTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "SearchHistoryTableViewCell"
    
    let leftLable = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 15)
        $0.textColor = .vegeTextBlackColor
    }
    private let rightAccessoryImageView = UIImageView().then {
        $0.image = UIImage(named: "searchHistory_ClearButton")
    }
    private var tapActionHandler: (Int) -> Void = { _ in return }
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setConstraints()
        addTapGesture()
    }
    
    private func setConstraints() {
        [leftLable, rightAccessoryImageView].forEach {
            addSubview($0)
        }
        
        leftLable.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        rightAccessoryImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(_:)))
        rightAccessoryImageView.addGestureRecognizer(tapGesture)
        rightAccessoryImageView.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Selectors
    @objc private func handleTapAction(_ sender: UITapGestureRecognizer) {
        tapActionHandler(rightAccessoryImageView.tag)
    }
    
    
    // MARK: - Helpers
    func configureCell(text: String, tag: Int, tapActionHandler: @escaping (Int) -> Void) {
        leftLable.text = text
        rightAccessoryImageView.tag = tag
        self.tapActionHandler = tapActionHandler
    }
    
}
