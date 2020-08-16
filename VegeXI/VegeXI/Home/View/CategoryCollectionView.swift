//
//  CategoryCollectionView.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/06.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class CategoryCollectionView: UIView {
    
    // MARK: - Properties
    
    lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: flowLayout)
    private let flowLayout = UICollectionViewFlowLayout()
    private let categoryList = ["전체", "식단", "장소"," 제품", "컨텐츠"]
    
    private let selectedUnderLineView = UIView().then {
        $0.backgroundColor = .vegeTextBlackColor
    }
    
    var tappedCategory: ((String) -> Void)?
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        backgroundColor = .white
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    }
    
    func configureUI() {
        [collectionView, selectedUnderLineView].forEach {
            addSubview($0)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .vegeLightGrayBorderColor
        
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-1)
            $0.height.equalTo(1)
        }
    }
    
}

// MARK: - CategoryCollectionViewDataSource

extension CategoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.categoryLabel.text = categoryList[indexPath.item]
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.selectCategory()
        
        UIView.animate(withDuration: 0.3) {
            self.selectedUnderLineView.snp.removeConstraints()
            self.selectedUnderLineView.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-2)
                $0.height.equalTo(2)
                $0.centerX.equalTo(cell.categoryLabel.snp.centerX)
                $0.width.equalTo(cell.categoryLabel.snp.width).offset(2)
            }
            self.layoutIfNeeded()
        }
        
        tappedCategory?(categoryList[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.deSelectCategory()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width / CGFloat(categoryList.count)
        return CGSize(width: cellWidth, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
