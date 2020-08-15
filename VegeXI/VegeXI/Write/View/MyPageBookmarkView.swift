//
//  MyPageBookmarkView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit


class MyPageBookmarkView: UIView {
    
    // MARK: - Properties
    let postTableview = UITableView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        postTableview.register(MyPageBookmarkableViewCell.self, forCellReuseIdentifier: MyPageBookmarkableViewCell.identifier)
        postTableview.rowHeight = 150
        postTableview.backgroundColor = .white
        postTableview.separatorStyle = .none
        postTableview.showsVerticalScrollIndicator = false
    }
    
    private func setConstraints() {
        [postTableview].forEach {
            self.addSubview($0)
        }
        postTableview.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
}

