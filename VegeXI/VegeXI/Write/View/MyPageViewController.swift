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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - UI
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
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    private func handleProfileEditButton() {
        let nextVC = EditProfileViewController()
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
