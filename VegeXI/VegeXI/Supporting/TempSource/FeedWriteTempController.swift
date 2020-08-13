//
//  FeedWriteController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FeedWriteTempController: UIViewController {
    
    // MARK: - Properties
    
    private let sidePadding: CGFloat = 20
    
    private lazy var navigationBar = WriteNavigationBar(title: "글쓰기").then {
        enabledWriteFeed = $0.enabledWriteFeed(isEnabled:)
    }
    private var enabledWriteFeed: ((Bool) -> ())?
    
    private let titlePlaceHolder = UILabel().then {
        $0.text = "제목을 입력해주세요"
        $0.textColor = .textViewPlaceholderTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 24)
    }
    private lazy var titleTextView = UITextView().then {
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 24)
        $0.isScrollEnabled = false
        $0.delegate = self
        
        $0.addSubview(titlePlaceHolder)
        titlePlaceHolder.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(6)
        }
    }
    
    private let titleTextViewUnderView = UIView().then {
        $0.backgroundColor = .vegeLightGrayCellBorderColor
    }
    
    private let contentPlaceHolder = UILabel().then {
        $0.text = "공유하고 싶은 내용을 입력해주세요!"
        $0.textColor = .textViewPlaceholderTextColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
    }
    private lazy var contentTextView = UITextView().then {
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.delegate = self
        
        $0.addSubview(contentPlaceHolder)
        contentPlaceHolder.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(6)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
    }
    
    // MARK: - Helpers
    
    func configureToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = .vegeTextBlackColor
        toolBar.backgroundColor = .white
        
        let cameraButton = UIBarButtonItem(
            image: UIImage(named: "toolbar_Camera_Icon"),
            style: .plain,
            target: nil,
            action: nil)
        
        let locationButton = UIBarButtonItem(
            image: UIImage(named: "toolbar_Location_Icon"),
            style: .plain,
            target: nil,
            action: nil)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        toolBar.setItems([cameraButton, locationButton], animated: true)
        
        contentTextView.inputAccessoryView = toolBar
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        [navigationBar, titleTextView, titleTextViewUnderView, contentTextView].forEach { view.addSubview($0) }
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(sidePadding)
            $0.trailing.equalToSuperview().offset(-sidePadding)
            $0.height.equalTo(50)
        }
        
        titleTextViewUnderView.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(sidePadding)
            $0.trailing.equalToSuperview().offset(-sidePadding)
            $0.height.equalTo(1)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextViewUnderView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(sidePadding)
            $0.trailing.equalToSuperview().offset(-sidePadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavi() {
        navigationController?.navigationBar.isHidden = true
    }
}


// MARK: - UITextViewDelegate

extension FeedWriteTempController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            titlePlaceHolder.isHidden = !(textView.text.isEmpty)
            
            let width = UIScreen.main.bounds.width - (sidePadding * 2)
            
            let size = CGSize(width: width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        } else if textView == contentTextView {
            contentPlaceHolder.isHidden = !(textView.text.isEmpty)
        }
        
        if !titleTextView.text.isEmpty &&
            !contentTextView.text.isEmpty {
            enabledWriteFeed?(true)
        } else {
            enabledWriteFeed?(false)
        }
    }
}
