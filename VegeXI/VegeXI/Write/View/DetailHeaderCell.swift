//
//  DetailHeaderCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/11.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class DetailHeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "DetailHeaderCell"
    
    let headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "feed_Example")
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        clipsToBounds = true
        
        addSubview(headerImageView)
        headerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    
}
