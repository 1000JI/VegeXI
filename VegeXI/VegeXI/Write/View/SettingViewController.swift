//
//  SettingViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: SettingViewStrings.barTitle.generateString())
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setStoredPropertyAttributes()
        setConstraints()
    }
    
    private func setStoredPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleTopBarLeftBarButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [topBarView].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTopBarLeftBarButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
