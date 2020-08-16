//
//  SharePostViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/11/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SharePostViewController: UIViewController {
    
    // MARK: - Properties
    typealias IndexPathSet = Set<IndexPath>
    private let sharePostScrollView = SharePostScrollView()
    private let bottomShareButtonBar = FilterViewBottomBar(title: GeneralStrings.share.generateString())
    private let data = MockData.newFilteredList
    
    private lazy var vegeInfoCollectionView = sharePostScrollView.sharePostContentView.vegeTypeInfoView.categoryCollectionView
    private lazy var categoryCollectionViews = sharePostScrollView.sharePostContentView.categoryViews // 컬렉션 뷰를 포함하는 모든 카테고리 뷰를 저장
    private var selectedCellInfo = [Int: IndexPathSet]() // 유저가 선택한 셀이 저장
    
    private var vegeType: VegeType { // 유저가 설정한 타입 값
        return configureVegeType(selectedCellInfo: selectedCellInfo)
    }
    private var categoryTitleType: CategoryType { // 각 카테고리를 구분하는 타이틀 저장
        return configureCategoryTitle(selectedCellInfo: selectedCellInfo)
    }
    private var categoryType: PostCategory { // 유저가 설정한 카테고리 값
        return configureCategory(selectedCellInfo: selectedCellInfo)
    }
    private var sharePostSetting: Bool { // 유저가 설정한 공개설정 값
        return sharePostScrollView.sharePostContentView.sharePostSettingSwitchView.isSwitchOn
    }
    
    private let backgroundColor = UIColor.black.withAlphaComponent(0.75)
    
    
    // Previous Data
    var feedTitle: String = ""
    var feedContent: String = ""
    var location: LocationModel?
    var imageArray = [UIImage]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let view = sharePostScrollView.sharePostContentView.sharePostSettingSwitchView
        sharePostScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: view.frame.maxY + 280)
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        vegeInfoCollectionView.delegate = self
        categoryCollectionViews.forEach {
            $0.collectionView.delegate = self
        }
        
        bottomShareButtonBar.configureBottomBar {
            self.handleShareButton()
        }
        sharePostScrollView.handleDismissAction = handleDismissAction
    }
    
    private func setConstraints() {
        [sharePostScrollView, bottomShareButtonBar].forEach {
            view.addSubview($0)
        }
        sharePostScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        bottomShareButtonBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(75)
        }
    }
    
    
    // MARK: - Helpers
    private func handleDismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getTextSize(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let key = data[collectionView.tag].keys.first!
        let text = data[collectionView.tag][key]![indexPath.item]
        let font = UIFont.spoqaHanSansRegular(ofSize: 13)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
    }
    
    private func handleShareButton() {
        guard selectedCellInfo.count == 2 else {
            let alert = UIAlertController(title: nil, message: "타입과 카테고리를 선택하세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true)
            return }
        
        let feedCategory = FeedCategory(
            vegeType: vegeType,
            categoryTitleType: categoryTitleType,
            categoryType: categoryType)
        
        showLoader(true)
        FeedService.shared.uploadFeed(
            title: feedTitle,
            content: feedContent,
            imageArray: imageArray,
            location: location,
            category: feedCategory,
            isOpen: sharePostSetting) { (error, ref) in
                self.showLoader(false)
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                print("FEED UPLOAD SUCCESS")
                self.presentingViewController?
                    .presentingViewController?
                    .dismiss(animated: true, completion: nil)
        }
    }
    
    private func configureVegeType(selectedCellInfo: [Int: IndexPathSet]) -> VegeType {
        guard let data = selectedCellInfo[0]?.first else { return .nothing }
        switch data.row {
        case 0:
            return .nothing
        case 1:
            return .vegan
        case 2:
            return .ovo
        case 3:
            return .lacto
        case 4:
            return .lacto_ovo
        case 5:
            return .pesco
        default:
            return .nothing
        }
    }
    
    private func configureCategoryTitle(selectedCellInfo: [Int: IndexPathSet]) -> CategoryType {
        for index in 1...4 {
            guard let _ = selectedCellInfo[index] else { continue }
            switch index {
            case 1:
                return .diet
            case 2:
                return .location
            case 3:
                return .product
            case 4:
                return .content
            default:
                fatalError()
            }
        }
        return .content
    }
    
    private func configureCategory(selectedCellInfo: [Int: IndexPathSet]) -> PostCategory {
        for index in 1...4 {
            guard let data = selectedCellInfo[index]?.first else { continue }
            switch index {
            case 1:
                switch data {
                case [0, 0]:
                    return .koreanFood
                case [0, 1]:
                    return .snackBar
                case [0, 2]:
                    return .japaneseFood
                case [0, 3]:
                    return .chineseFood
                case [0, 4]:
                    return .westernFood
                case [0, 5]:
                    return .eastAsianFood
                case [0, 6]:
                    return .indianFood
                case [0, 7]:
                    return .breadAndCoffee
                case [0, 8]:
                    return .alcohol
                default:
                    return .noInfo
                }
            case 2:
                switch data {
                case [0, 0]:
                    return .restuarant
                case [0, 1]:
                    return .bakeryAndCafe
                case [0, 2]:
                    return .houseHoldGoodsStore
                case [0, 3]:
                    return .Exhibition
                default:
                    return .noInfo
                }
            case 3:
                switch data {
                case [0, 0]:
                    return .cosmetics
                case [0, 1]:
                    return .houseHoldGoods
                case [0, 2]:
                    return .fashion
                default:
                    return .noInfo
                }
            case 4:
                switch data {
                case [0, 0]:
                    return .influencer
                case [0, 1]:
                    return .book
                case [0, 2]:
                    return .movie
                case [0, 3]:
                    return .documentary
                default:
                    return .noInfo
                }
                
            default:
                return .noInfo
            }
        }
        return .noInfo
    }
}
    


// MARK: - UICollectionViewDelegateFlowLayout
extension SharePostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 26
        let width = getTextSize(collectionView: collectionView, indexPath: indexPath).width + padding
        return CGSize(width: width, height: 29)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    
}



// MARK: - UICollectionViewDelegate
extension SharePostViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 모든 카테고리를 컬렉션뷰를 순환하며 단 하나의 셀만 선택될 수 있도록 세팅
        guard let cell = collectionView.cellForItem(at: indexPath) as? SharePostCollectionViewCell else { print("Guare Activated, \(#function)"); return }
        if collectionView.tag != 0 {
            let placeholder = selectedCellInfo[0]
            selectedCellInfo.removeAll()
            selectedCellInfo[0] = placeholder
            
            categoryCollectionViews.forEach {
                $0.collectionViewCells.forEach {
                    $0.isClicked = false
                }
            }
        }
        cell.isClicked = true
        selectedCellInfo[collectionView.tag] = [indexPath]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SharePostCollectionViewCell else { print("Guare Activated, \(#function)"); return }
        cell.isClicked = false
    }
    
}
