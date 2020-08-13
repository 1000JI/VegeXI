//
//  WriteImageTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class WriteImageTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "WriteImageTableCell"
    private let sideInsetValue: CGFloat = 20
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        
        $0.register(
            WriteImageCollectionCell.self,
            forCellWithReuseIdentifier: WriteImageCollectionCell.identifier)
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
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(collectionView.snp.width)
        }
    }
}


// MARK: - UICollectionViewDataSource

extension WriteImageTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteImageCollectionCell.identifier, for: indexPath) as! WriteImageCollectionCell
        
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension WriteImageTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.width - (sideInsetValue * 2)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: sideInsetValue, left: sideInsetValue, bottom: sideInsetValue, right: sideInsetValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}



// MARK: - WriteImageCollectionCell

class WriteImageCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "WriteImageCollectionCell"
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    
}
