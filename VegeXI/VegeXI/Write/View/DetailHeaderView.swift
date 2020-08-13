//
//  DetailHeaderView.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/11.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import SDWebImage

class DetailHeaderView: UIView {
    
    // MARK: - Properties
    
    var feed: Feed? {
        didSet { configure() }
    }
    
    private let defaultSidePadding: CGFloat = 20
    private let buttonSize: CGFloat = 34
    
    var tappedMoreButton: (() -> ())?
    var tappedLikeButton: (() -> ())?
    var tappedBookmarkButton: (() -> ())?
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.register(DetailHeaderCell.self,
                        forCellWithReuseIdentifier: DetailHeaderCell.identifier)
            $0.dataSource = self
            $0.delegate = self
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
    }
    private let moreImageCountLabel = UILabel().then {
        $0.text = "1/3"
        $0.textColor = .white
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
    }
    private let moreCountLabelBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cell_Human")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        $0.layer.cornerRadius = 40 / 2
    }
    
    private let writerLabel = UILabel().then {
        $0.text = "작성자"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansBold(ofSize: 14)
    }
    
    private let writeDateLabel = UILabel().then {
        $0.text = "2020.01.01"
        $0.textColor = .vegeCategoryTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 10)
    }
    
    private lazy var writeStack = UIStackView(
        arrangedSubviews: [writerLabel, writeDateLabel])
    
    private lazy var profileStack = UIStackView(
        arrangedSubviews: [profileImageView, writeStack])
    
    private lazy var moreButton = UIButton(type: .system).then {
        let image = UIImage(named: "cell_MoreButton")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.snp.makeConstraints {
            $0.height.width.equalTo(44)
        }
        $0.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
    }
    
    private let detailTitleLabel = UILabel().then {
        $0.text = "피드 타이틀 제목"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansBold(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    private lazy var likeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feed_Heart"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
        $0.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
    }
    
    private let likesCountLabel = UILabel().then {
        $0.text = "12"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 11)
    }
    
    private lazy var commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feed_Comment"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
    }
    
    private let commentCountLabel = UILabel().then {
        $0.text = "12"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 11)
    }
    
    private lazy var bookmarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "feed_Bookmark"), for: .normal)
        $0.tintColor = .vegeTextBlackColor
        $0.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "컨텐츠 내용"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 12)
        $0.numberOfLines = 0
    }
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moreCountLabelBackView.layer.cornerRadius = moreCountLabelBackView.frame.height / 2
    }
    
    
    // MARK: - Actions
    
    @objc func buttonEvent(_ sender: UIButton) {
        switch sender {
        case likeButton:
            tappedLikeButton?()
        case bookmarkButton:
            tappedBookmarkButton?()
        case moreButton:
            tappedMoreButton?()
        default:
            break
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        writeStack.axis = .vertical
        
        profileStack.axis = .horizontal
        profileStack.spacing = 8
        profileStack.alignment = .center
        
        [profileStack, moreButton, detailTitleLabel, collectionView, likeButton, likesCountLabel, commentButton, commentCountLabel, bookmarkButton, contentLabel, moreCountLabelBackView, moreImageCountLabel].forEach {
            addSubview($0)
        }
        profileStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(defaultSidePadding)
            $0.height.equalTo(40)
        }
        moreButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        detailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileStack.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(defaultSidePadding)
            $0.trailing.equalToSuperview().offset(-defaultSidePadding)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(detailTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(defaultSidePadding)
            $0.trailing.equalToSuperview().offset(-defaultSidePadding)
            $0.height.equalTo(collectionView.snp.width)
        }
        moreCountLabelBackView.snp.makeConstraints {
            $0.center.equalTo(moreImageCountLabel.snp.center)
            $0.width.equalTo(moreImageCountLabel.snp.width).offset(24)
            $0.height.equalTo(moreImageCountLabel.snp.height).offset(8)
        }
        moreImageCountLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top).offset(16)
            $0.trailing.equalTo(collectionView.snp.trailing).offset(-20)
        }
        
        likeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(collectionView.snp.bottom).offset(0)
            $0.width.height.equalTo(buttonSize)
        }
        likesCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.trailing).offset(-4)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.equalTo(24)
        }
        commentButton.snp.makeConstraints {
            $0.leading.equalTo(likesCountLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.height.equalTo(buttonSize)
        }
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentButton.snp.trailing).offset(-4)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.equalTo(24)
        }
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.width.height.equalTo(buttonSize)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(defaultSidePadding)
            $0.trailing.equalToSuperview().offset(-defaultSidePadding)
        }
        
        let finishLineView = UIView()
        finishLineView.backgroundColor = UIColor(rgb: 0xDADBDA)
        addSubview(finishLineView)
        finishLineView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func configure() {
        guard let feed = feed else { return }
        let viewModel = DetailViewModel(feed: feed)
        
        switch feed.feedType {
        case .textType:
            showDetailImages(isShow: false)
        case .picAndTextType:
            showDetailImages(isShow: true)
            moreImageCountLabel.text = "1/\(feed.imageUrls!.count)"
            collectionView.reloadData()
        }
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        writerLabel.text = feed.writerUser.nickname
        writeDateLabel.text = viewModel.writeDate
        detailTitleLabel.text = feed.title
        contentLabel.text = feed.content
        
        likeButton.setImage(viewModel.likeImage, for: .normal)
        likesCountLabel.text = "\(feed.likes)"
        commentCountLabel.text = "\(feed.comments)"
        bookmarkButton.setImage(viewModel.bookmarkImage, for: .normal)
    }
    
    func showDetailImages(isShow: Bool) {
        collectionView.snp.removeConstraints()
        likeButton.snp.removeConstraints()
        
        moreImageCountLabel.isHidden = !isShow
        moreCountLabelBackView.isHidden = !isShow
        
        if isShow {
            collectionView.snp.makeConstraints {
                $0.top.equalTo(detailTitleLabel.snp.bottom).offset(12)
                $0.leading.equalToSuperview().offset(defaultSidePadding)
                $0.trailing.equalToSuperview().offset(-defaultSidePadding)
                $0.height.equalTo(collectionView.snp.width)
            }
            likeButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(12)
                $0.top.equalTo(collectionView.snp.bottom).offset(0)
                $0.width.height.equalTo(buttonSize)
            }
        } else {
            likeButton.snp.makeConstraints {
                $0.top.equalTo(detailTitleLabel.snp.bottom).offset(12)
                $0.leading.equalToSuperview().offset(12)
                $0.width.height.equalTo(buttonSize)
            }
        }
    }
}


// MARK: - UICollectionViewDataSource

extension DetailHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let feed = feed else { return 0 }
        let imageCount = feed.imageUrls?.count ?? 0
        return imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailHeaderCell.identifier,
            for: indexPath) as! DetailHeaderCell
        guard let feed = feed else { return cell }
        cell.headerImageView.sd_setImage(with: feed.imageUrls?[indexPath.item])
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension DetailHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.width - (defaultSidePadding * 2)
        return CGSize(width: size, height: size)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let amountCount = feed?.imageUrls?.count else { return }
        
        let width = UIScreen.main.bounds.width - (defaultSidePadding * 2)
        let presentX = scrollView.contentOffset.x
        let pageNumber = Int(presentX / width) + 1
        moreImageCountLabel.text = "\(pageNumber)/\(amountCount)"
    }
}
