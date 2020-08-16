//
//  ExplanationViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class ExplanationViewController: UIViewController {
    
    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: "")
    private let scrollView = UIScrollView()
    private let contentLabel = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 13)
        $0.textColor = .vegeTextBlackColor
        $0.numberOfLines = 0
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTabbarHidden(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabbarHidden(isHidden: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentLabel.frame.maxY)
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleLeftBarButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [topBarView, scrollView].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentLabel)
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleLeftBarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helpers
    func configureViewController(title: String, content: String) {
        topBarView.barTitle.text = title
        contentLabel.text = content
    }
    
}
