//
//  MyPagePostView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPagePostView: UIView {
    
    // MARK: - Properties
    let postTableview = UITableView()

    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        postTableview.register(MyPagePostTableViewCell.self, forCellReuseIdentifier: MyPagePostTableViewCell.identifier)
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


