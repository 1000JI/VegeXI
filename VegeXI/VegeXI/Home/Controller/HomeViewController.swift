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
    private let refreshControl = UIRefreshControl()
    
    private var feeds = [Feed]() {
        didSet { mainTableView.feeds = feeds }
    }
    private var filterFeeds = [Feed]() {
        didSet { mainTableView.filterFeeds = filterFeeds }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureViewEvent()
        fetchFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
//        fetchFeeds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentWriteButtonInTabBar()
        
        let indexPath = IndexPath(item: 0, section: 0)
        categoryView.collectionView.selectItem(
            at: indexPath,
            animated: false,
            scrollPosition: .centeredHorizontally)
        categoryView.collectionView(
            categoryView.collectionView,
            didSelectItemAt: indexPath)
    }
    
    // MARK: - API
    
    func fetchFeeds() {
        showLoader(true)
        FeedService.shared.fetchFeeds { feeds in
            self.showLoader(false)
            self.refreshControl.endRefreshing()
            self.feeds = feeds
        }
    }
    
    
    // MARK: - Actions
    
    func tappedSearchButton() {
        let controller = SearchHistoryViewController()
        controller.feeds = feeds
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tappedAlertButton() {
        print(#function)
    }
    
    func tappedSortEvent() {
        let sortAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let newestSortAction = UIAlertAction(
            title: "최신순",
            style: .default) { action in
                self.feeds = self.feeds
        }
        let popularSortAction = UIAlertAction(
            title: "인기순",
            style: .default) { action in
                self.filterFeeds = self.feeds.sorted(by: { lhs, rhs -> Bool in
                    lhs.likes > rhs.likes
                })
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil)
        sortAlert.addAction(newestSortAction)
        sortAlert.addAction(popularSortAction)
        sortAlert.addAction(cancelAction)
        sortAlert.view.tintColor = .vegeTextBlackColor
        
        present(sortAlert, animated: true)
    }
    
    func tappedFilterEvent() {
        let filterController = NewFilterViewController()
        filterController.modalPresentationStyle = .fullScreen
        present(filterController, animated: true)
    }
    
    func tappedCommentEvent(feed: Feed) {
        let controller = FeedDetailController()
        controller.feed = feed
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Selectors
    
    @objc func handleRefresh() {
        fetchFeeds()
    }
    
    
    // MARK: - Helpers
    
    func configureViewEvent() {
        homeCustomNavigationBar.tappedSearchButton = tappedSearchButton
        homeCustomNavigationBar.tappedAlertButton = tappedAlertButton
    }
    
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
    
    func configureTableView() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        mainTableView.refreshControl = refreshControl
        mainTableView.handleSortTapped = tappedSortEvent
        mainTableView.handleFilterTapped = tappedFilterEvent
        mainTableView.handleCommentTapped = tappedCommentEvent(feed:)
    }
}
