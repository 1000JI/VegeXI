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
    let sharePostScrollView = SharePostScrollView()
    let bottomShareButtonBar = FilterViewBottomBar(title: GeneralStrings.share.generateString())
    let data = MockData.newFilteredList
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sharePostScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2)
    }
    

    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        sharePostScrollView.sharePostContentView.vegeTypeInfoView.categoryCollectionView.delegate = self
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
    func getTextSize(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let key = data[collectionView.tag].keys.first!
        let text = data[collectionView.tag][key]![indexPath.item]
        let font = UIFont.spoqaHanSansRegular(ofSize: 13)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
    }

}


// MARK: - UICollectionViewDelegate
extension SharePostViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
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
