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
    
    private let backgroundColor = UIColor.black.withAlphaComponent(0.75)
    
    
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
    private func getTextSize(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let key = data[collectionView.tag].keys.first!
        let text = data[collectionView.tag][key]![indexPath.item]
        let font = UIFont.spoqaHanSansRegular(ofSize: 13)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
    }
    
    private func handleShareButton() {
        print(#function)
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
        print(selectedCellInfo)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SharePostCollectionViewCell else { print("Guare Activated, \(#function)"); return }
        cell.isClicked = false
    }
    
}
