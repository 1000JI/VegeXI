//
//  MyPagePostTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPagePostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "MyPagePostTableViewCell"
    
    private let postTitle = UILabel()
    private let postSubtitle = UILabel()
    private let postImage = UIImageView()
    private let postingDate = UILabel()
    private let likeIcon = UIImageView()
    private let likes = UILabel()
    private let commentIcon = UIImageView()
    private let comments = UILabel()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .green
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
        
    }
    
    private func setConstraints() {
        
    }
    
    
    
}
