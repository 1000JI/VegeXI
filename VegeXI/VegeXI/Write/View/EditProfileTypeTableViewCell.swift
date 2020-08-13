//
//  EditProfileTypeTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class EditProfileTypeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "EditProfileTypeTableViewCell"
    
    private let selectionBorderView = UIView().then {
        $0.layer.cornerRadius = 28 / 2
        $0.layer.borderColor = UIColor.textViewPlaceholderTextColor.cgColor
        $0.layer.borderWidth = 0.5
    }
    private let selectedEffectView = UIView().then {
        $0.layer.cornerRadius = 16 / 2
        $0.backgroundColor = .buttonEnabledTextcolor
        $0.layer.borderColor = UIColor.buttonEnabledTextcolor.cgColor
        $0.alpha = 0
    }
    private let cellTitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansBold(ofSize: 13)
    }
    private let infoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let separator = UIView().then {
        $0.backgroundColor = .vegeLightGraySearchBarColor
    }
    var isClicked = false {
        willSet {
            selectedEffectView.alpha = newValue ? 1 : 0
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
        [selectionBorderView, cellTitle, infoImageView, separator].forEach {
            self.addSubview($0)
        }
        selectionBorderView.addSubview(selectedEffectView)
        selectionBorderView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(28)
        }
        selectedEffectView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(16)
        }
        cellTitle.snp.makeConstraints {
            $0.centerY.equalTo(selectionBorderView)
            $0.leading.equalTo(selectionBorderView.snp.trailing).offset(24)
        }
        infoImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.equalTo(150)
            $0.centerY.equalTo(selectionBorderView)
            $0.height.equalTo(24)
        }
        separator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    
    // MARK: - Methods
    func configureCell(title text: String, imageName image: String, isSelected isClicked: Bool, separatorAlpha: CGFloat) {
        cellTitle.text = text
        self.isClicked = isClicked
        self.separator.alpha = separatorAlpha
        guard image != "" else { return }
        infoImageView.image = UIImage(named: image)
    }
    
}
