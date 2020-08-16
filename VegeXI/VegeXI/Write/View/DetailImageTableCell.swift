//
//  DetailImageTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/14.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class DetailImageTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "DetailImageTableCell"
    private let sideInsetValue: CGFloat = 20
    
    var imageUrlArray = [URL]() {
        didSet {
            configure()
            collectionView.reloadData()
        }
    }
    
    private let moreImageCountLabel = UILabel().then {
        $0.text = "1/3"
        $0.textColor = .white
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
    }
    
    private let moreCountLabelBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.dataSource = self
        $0.delegate = self
        
        $0.register(
            DetailImageCollectionCell.self,
            forCellWithReuseIdentifier: DetailImageCollectionCell.identifier)
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moreCountLabelBackView.layer.cornerRadius = moreCountLabelBackView.frame.height / 2
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(collectionView)
        addSubview(moreCountLabelBackView)
        addSubview(moreImageCountLabel)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(sideInsetValue)
            $0.trailing.equalToSuperview().offset(-sideInsetValue)
            $0.height.equalTo(collectionView.snp.width)
        }
        
        moreCountLabelBackView.snp.makeConstraints {
            $0.center.equalTo(moreImageCountLabel.snp.center)
            $0.width.equalTo(moreImageCountLabel.snp.width).offset(24)
            $0.height.equalTo(moreImageCountLabel.snp.height).offset(8)
        }
        
        moreImageCountLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView).offset(16)
            $0.trailing.equalTo(collectionView).offset(-20)
        }
    }
    
    func configure() {
        if imageUrlArray.count > 1 {
            moreImageCountLabel.text = "1/\(imageUrlArray.count)"
        } else {
            moreImageCountLabel.isHidden = true
            moreCountLabelBackView.isHidden = true
        }
    }
}


// MARK: - UICollectionViewDataSource

extension DetailImageTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCollectionCell.identifier, for: indexPath) as! DetailImageCollectionCell
        
        cell.configure(url: imageUrlArray[indexPath.item])
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension DetailImageTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.width - (sideInsetValue * 2)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = UIScreen.main.bounds.width - (20 * 2)
        let presentX = scrollView.contentOffset.x
        let pageNumber = Int(presentX / width) + 1
        moreImageCountLabel.text = "\(pageNumber)/\(imageUrlArray.count)"
    }
}



// MARK: - WriteImageCollectionCell

class DetailImageCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "DetailImageCollectionCell"
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .systemFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
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
    
    func configure(url: URL?) {
        imageView.sd_setImage(with: url)
    }
}
