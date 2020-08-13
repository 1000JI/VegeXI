//
//  VegetarianInfoView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/10/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class VegetarianInfoView: UIView {
    
    // MARK: - Properties
    let imageView = UIImageView()
    
    let infoStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 2
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .vegeLightGrayForInfoView
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        addSubview(infoStackView)
//        infoStackView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
    }
    
    
    // MARK: - Helpers
    private func generateStackViews() {
        let data = MockData.vegetarianInfo
        for index in data.indices {
            guard let key = data[index].first?.key else { return }
            let title = UILabel().then {
                $0.text = key
            }
            for itemCount in data.indices {
                let item = data[index][key]![itemCount]
                print(item)
            }
            print(title)
        }
    }
}
