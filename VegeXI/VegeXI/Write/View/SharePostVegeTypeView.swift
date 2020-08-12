//
//  SharePostVegeTypeView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/12/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SharePostVegeTypeView: UIView {
    
    
    // MARK: - Properties
    private let viewTitle = UILabel().then {
        $0.text = SharePostStrings.vegeType.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 17)
        $0.textColor = .vegeTextBlackColor
    }
    private let underBar = UIView().then {
        $0.backgroundColor = .vegeLightGrayVegeInfoThinBar
    }
    lazy var categoryCollectionView: UICollectionView = {
        let flowLayout = AlignedCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.horizontalAlignment = .leading
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.tag = self.tag
        return collectionView
    }()
    private let infoImageView = UIImageView().then {
        $0.image = UIImage(named: "newVegeInfo")
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    private let data = MockData.newFilteredList[0]["지향하는 채식 타입"]!
    
    
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
        categoryCollectionView.register(SharePostCollectionViewCell.self, forCellWithReuseIdentifier: SharePostCollectionViewCell.identifier)
        categoryCollectionView.dataSource = self
//        categoryCollectionView.delegate = self
        categoryCollectionView.isScrollEnabled = false
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.backgroundColor = .white
    }
    
    private func setConstraints() {
        [viewTitle, underBar, categoryCollectionView, infoImageView].forEach {
            self.addSubview($0)
        }
        viewTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        underBar.snp.makeConstraints {
            $0.top.equalTo(viewTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(underBar.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(underBar).inset(4)
            $0.height.equalTo(90)
        }
        infoImageView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(categoryCollectionView)
            $0.height.equalTo(200)
        }
    }
    
    
    // MARK: - Helpers
    func getTextSize(indexPath: IndexPath) -> CGSize {
        let text = data[indexPath.item]
        let font = UIFont.spoqaHanSansRegular(ofSize: 13)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
    }
    
}


// MARK: - UICollectionViewDataSource
extension SharePostVegeTypeView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: SharePostCollectionViewCell.identifier, for: indexPath) as? SharePostCollectionViewCell else { fatalError("No Cell Info") }
        let title = data[indexPath.item]
        cell.configureCell(title: title, tag: self.tag)
        return cell
    }
    
}
