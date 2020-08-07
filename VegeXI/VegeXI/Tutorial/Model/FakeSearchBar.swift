//
//  FakeSearchBar.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FakeSearchBar: UIView {
    
    // MARK: - Properties
    private let leftIcon = UIImageView().then {
        $0.image = UIImage(named: "searchBar_MaginifierIcon")
    }
    private let rightIcon = UIImageView().then {
        $0.image = UIImage(named: "searchBar_ClearIcon")
        $0.alpha = 0
    }
    let searchTextField = UITextField().then {
        $0.font = UIFont.spoqaHanSansBold(ofSize: 14)
        $0.textColor = .vegeTextBlackColor
    }
    private let searchFieldPlaceHolder = UILabel().then {
        $0.text = GeneralStrings.searchFieldPlaceholder.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.textColor = .vegeGraySearchBarPlaceHolderColor
    }
    
    var isSearching = false {
        willSet {
            rightIcon.alpha = newValue ? 1 : 0
            searchFieldPlaceHolder.alpha = newValue ? 0 : 1
        }
    }
    var currentText: String {
        get {
            guard let text = searchTextField.text else { return "" }
            return text
        } set {
            searchTextField.text = newValue
        }
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .vegeLightGraySearchBarColor
        searchTextField.delegate = self
        configureUI()
        setTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setConstraints()
        self.layer.cornerRadius = 17.5
    }
    
    private func setConstraints() {
        [leftIcon, rightIcon, searchTextField, searchFieldPlaceHolder].forEach {
            addSubview($0)
        }
        
        leftIcon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(36)
            $0.centerY.equalToSuperview()
        }
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(leftIcon.snp.trailing)
            $0.trailing.equalTo(rightIcon.snp.leading)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
        searchFieldPlaceHolder.snp.makeConstraints {
            $0.leading.equalTo(searchTextField)
            $0.centerY.equalToSuperview()
        }
        rightIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    
    // MARK: - Helpers
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        rightIcon.addGestureRecognizer(tap)
        rightIcon.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Selectors
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        searchTextField.text = ""
    }
}


extension FakeSearchBar: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isSearching = searchTextField.text != "" ? true : false
    }
}
