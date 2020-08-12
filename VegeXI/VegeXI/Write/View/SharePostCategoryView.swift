//
//  SharePostCategoryView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/12/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SharePostCategoryView: UIView {
    
    // MARK: - Properties
    private let categoryTitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansBold(ofSize: 14)
        $0.textColor = .vegeTextBlackColor
    }
    let foldButton = UIButton().then {
        let image = UIImage(systemName: "chevron.down")?.withTintColor(.vegeTextBlackColor, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
    }
    private let underBar = UIView().then {
        $0.backgroundColor = .vegeLightGrayVegeInfoThinBar
    }
    private lazy var collectionView: UICollectionView = {
        let flowLayout = AlignedCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.horizontalAlignment = .leading
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.tag = self.tag
        return collectionView
    }()
    var data = [String]()
    
    private var isFolded: Bool = false {
        willSet {
            foldButton.setImage(configureButtonImage(newValue: newValue), for: .normal)
        }
    }
    
    
    // MARK: - Lifecycle
    init(title text: String, isFolded: Bool, data: [String]) {
        super.init(frame: .zero)
        categoryTitle.text = text
        self.isFolded = isFolded
        self.data = data
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
        collectionView.register(SharePostCollectionViewCell.self, forCellWithReuseIdentifier: SharePostCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
    }
    
    private func setConstraints() {
        [categoryTitle, foldButton, underBar, collectionView].forEach {
            self.addSubview($0)
        }
        switch isFolded {
        case true:
            setConstraintsForFoldedStatus()
        case false:
            setConstraintsForUnfoldedStatus()
        }
    }
    
    private func setConstraintsForFoldedStatus() {
        categoryTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(3)
        }
        foldButton.snp.makeConstraints {
            $0.top.equalTo(categoryTitle)
            $0.trailing.equalToSuperview().inset(3)
        }
        underBar.snp.makeConstraints {
            $0.top.equalTo(categoryTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(underBar.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.height.equalTo(90)
        }
    }
    
    private func setConstraintsForUnfoldedStatus() {
        categoryTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(3)
        }
        foldButton.snp.makeConstraints {
            $0.top.equalTo(categoryTitle)
            $0.trailing.equalToSuperview().inset(3)
        }
        underBar.snp.makeConstraints {
            $0.top.equalTo(categoryTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(underBar.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.height.equalTo(90)
        }
    }
    
    
    // MARK: - Helpers
    private func configureButtonImage(newValue: Bool) -> UIImage {
        guard let unfoldedImage = UIImage(systemName: "chevron.up")?.withTintColor(.vegeTextBlackColor, renderingMode: .alwaysOriginal) else { return UIImage() }
        guard let foldedImage = UIImage(systemName: "chevron.down")?.withTintColor(.vegeTextBlackColor, renderingMode: .alwaysOriginal) else { return UIImage() }
        let image = newValue ? foldedImage : unfoldedImage
        return image
    }
    
    
    func getTextSize(indexPath: IndexPath) -> CGSize {
        let text = data[indexPath.item]
        let font = UIFont.spoqaHanSansRegular(ofSize: 13)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
    }
    
}


// MARK: - UICollectionViewDataSource
extension SharePostCategoryView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SharePostCollectionViewCell.identifier, for: indexPath) as? SharePostCollectionViewCell else { fatalError() }
        let title = data[indexPath.item]
        cell.configureCell(title: title, tag: self.tag)
        return cell
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout
extension SharePostCategoryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 26
        let width = getTextSize(indexPath: indexPath).width + padding
        return CGSize(width: width, height: 29)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
}


extension SharePostCategoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.tag)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}
