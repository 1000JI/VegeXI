//
//  MyPageViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {

    // MARK: - Properties
    private let topBarView = MyPageTopBarView()
    private let profileView = MyPageProfileView()
    private let categoryView = MyPageCategoryView()
    private let postView = MyPagePostView()
    private let bookmarkView = MyPageBookmarkView()
    private lazy var categorySubviews = [postView, bookmarkView]
    
    private var myFeeds = [Feed]()
    private var bookmarkFeeds = [Feed]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        fetchMyFeeds()
        fetchMyBookmarkFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentWriteButtonInTabBar()
    }
    
    // MARK: - API
    func fetchMyFeeds() { // 내 글 가져오기
        showLoader(true)
        
        guard let userUid = UserService.shared.user?.uid else { return }
        FeedService.shared.fetchMyFeeds(userUid: userUid) { feeds in
            self.showLoader(false)
            self.myFeeds = feeds
            
            self.myFeeds.forEach { tweet in
                FeedService.shared.checkIfUserLikedAndBookmarkFeed(
                feedID: tweet.feedID) { (didLike, didBookmark) in
                    guard didLike == true || didBookmark == true else { return }
                    
                    if let index = self.myFeeds.firstIndex(where: {
                        $0.feedID == tweet.feedID
                    }) {
                        self.myFeeds[index].didLike = didLike
                        self.myFeeds[index].didBookmark = didBookmark
                    }
                }
            }
        }
    }
    
    func fetchMyBookmarkFeeds() { // 내가 북마크 한 글 가져오기
        guard let userUid = UserService.shared.user?.uid else { return }
        FeedService.shared.fetchMyBookmark(userUid: userUid) { feeds in
            self.bookmarkFeeds = feeds
            
            self.bookmarkFeeds.forEach { tweet in
                FeedService.shared.checkIfUserLikedAndBookmarkFeed(
                feedID: tweet.feedID) { (didLike, didBookmark) in
                    guard didLike == true || didBookmark == true else { return }
                    
                    if let index = self.bookmarkFeeds.firstIndex(where: {
                        $0.feedID == tweet.feedID
                    }) {
                        self.bookmarkFeeds[index].didLike = didLike
                        self.bookmarkFeeds[index].didBookmark = didBookmark
                    }
                }
            }
        }
    }
    
    
    // MARK: - UI
    private func configureNavi() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        setStoredPropertyAttributes()
        setConstraints()
    }
    
    private func setStoredPropertyAttributes() {
        topBarView.rightBarButton.addTarget(self, action: #selector(handleTopRightBarButton(_:)), for: .touchUpInside)
        profileView.profileEditButton.addTarget(self, action: #selector(handleProfileEditButton), for: .touchUpInside)
        
        postView.tag = 0
        bookmarkView.tag = 1
        categoryView.prepareForActions(action: controlSections(selectedSectionNumber:))
        
        guard let user = UserService.shared.user else { return }
        profileView.userData = user
    }
    
    private func setConstraints() {
        [topBarView, profileView, categoryView, postView, bookmarkView].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(213)
        }
        categoryView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        postView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        bookmarkView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTopRightBarButton(_ sender: UIButton) {
        let nextVC = SettingViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    private func handleProfileEditButton() {
        let nextVC = EditProfileViewController()
        nextVC.hidesBottomBarWhenPushed = true
        
        guard let user = UserService.shared.user else { return }
        nextVC.user = user
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    // MARK: - Helpers
    private func controlSections(selectedSectionNumber: Int) {
        print(#function)
        categorySubviews.forEach {
            if $0.tag == selectedSectionNumber {
                $0.isHidden = false
            } else {
                $0.isHidden = true
            }
        }
    }
    
}
