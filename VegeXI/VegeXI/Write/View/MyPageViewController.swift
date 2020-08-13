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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setStoredPropertyAttributes()
        setConstraints()
    }
    
    private func setStoredPropertyAttributes() {
        topBarView.rightBarButton.addTarget(self, action: #selector(handleTopRightBarButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [topBarView, profileView, categoryView].forEach {
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
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTopRightBarButton(_ sender: UIButton) {
        let nextVC = EditProfileViewController()
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }

}
