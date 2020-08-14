//
//  DetailHeaderView.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/11.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {
    
    // MARK: - Properties
    
    var feed: Feed? {
        didSet { configure() }
    }
    
    private let defaultSidePadding: CGFloat = 20
    
    var tappedMoreButton: (() -> ())?
    
    private let moreImageCountLabel = UILabel().then {
        $0.text = "1/3"
        $0.textColor = .white
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
    }
    private let moreCountLabelBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cell_Human")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        $0.layer.cornerRadius = 40 / 2
    }
    
    private let writerLabel = UILabel().then {
        $0.text = "작성자"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansBold(ofSize: 14)
    }
    
    private let writeDateLabel = UILabel().then {
        $0.text = "2020.01.01"
        $0.textColor = .vegeCategoryTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 10)
    }
    
    private lazy var writeStack = UIStackView(
        arrangedSubviews: [writerLabel, writeDateLabel])
    
    private lazy var profileStack = UIStackView(
        arrangedSubviews: [profileImageView, writeStack])
    
    private lazy var moreButton = UIButton(type: .system).then {
        let image = UIImage(named: "cell_MoreButton")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.snp.makeConstraints {
            $0.height.width.equalTo(44)
        }
        $0.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
    }
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    @objc func buttonEvent(_ sender: UIButton) {
        tappedMoreButton?()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        writeStack.axis = .vertical
        
        profileStack.axis = .horizontal
        profileStack.spacing = 8
        profileStack.alignment = .center
        
        [profileStack, moreButton].forEach {
            addSubview($0)
        }
        profileStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(defaultSidePadding)
        }
        moreButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
    }
    
    func configure() {
        guard let feed = feed else { return }
        let viewModel = DetailViewModel(feed: feed)
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        writerLabel.text = feed.writerUser.nickname
        writeDateLabel.text = viewModel.writeDate
    }
}
