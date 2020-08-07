//
//  HomeViewController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/05.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeCustomNavigationBar = CustomMainNavigationBar()
    private let categoryView = CategoryCollectionView()
    private let mainTableView = MainTableView(frame: .zero, style: .grouped)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: 0, section: 0)
        categoryView.collectionView.selectItem(
            at: indexPath,
            animated: false,
            scrollPosition: .centeredHorizontally)
        categoryView.collectionView(
            categoryView.collectionView,
            didSelectItemAt: indexPath)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        [homeCustomNavigationBar, categoryView, mainTableView].forEach {
            view.addSubview($0)
        }
        
        homeCustomNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(homeCustomNavigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        // https://developer.apple.com/forums/thread/120790
        DispatchQueue.main.async { // Layout Warning
            self.mainTableView.snp.makeConstraints {
                $0.top.equalTo(self.categoryView.snp.bottom)
                $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    func configureNavi() {
        navigationController?.navigationBar.isHidden = true
    }
}
