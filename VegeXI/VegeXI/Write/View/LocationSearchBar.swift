//
//  LocationSearchBar.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/13.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class LocationSearchBar: UIView {
    
    // MARK: - Properties
    
    var searchKeywordEvent: ((String) -> Void)?
    
    private lazy var searchTextField = UITextField().then {
        $0.placeholder = "장소명을 입력하세요."
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .search
        $0.delegate = self
    }
    
    private lazy var searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(
            named: "searchBar_MaginifierIcon")?
            .withRenderingMode(.alwaysOriginal),
                    for: .normal)
        $0.addTarget(self, action: #selector(tappedSearchButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    
    func searchKeywordSend(text: String) {
        searchKeywordEvent?(text)
    }
    
    
    // MARK: - Selectors
    
    @objc
    func tappedSearchButton(_ sender: UIButton) {
        guard let text = searchTextField.text,
            !text.isEmpty else { return }
        searchKeywordSend(text: text)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        layer.borderColor = UIColor(rgb: 0xA5A5A5).cgColor
        layer.borderWidth = 1
        
        [searchTextField, searchButton].forEach { addSubview($0) }
        
        searchTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(searchButton.snp.height)
        }
    }
}


// MARK: - UITextFieldDelegate

extension LocationSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
            !text.isEmpty else { return false }
        searchKeywordSend(text: text)
        return true
    }
}
