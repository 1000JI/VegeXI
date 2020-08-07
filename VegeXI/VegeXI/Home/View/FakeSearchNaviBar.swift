//
//  FakeSearchNaviBar.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FakeSearchNaviBar: UIView {
    
    // MARK: - Properties
    private let leftBarButton = UIButton().then {
        $0.setImage(UIImage(named: "naviBar_BackBtnIcon"), for: .normal)
    }
    let fakeSearchBar = FakeSearchBar()
    private var leftBarButtonActionHandler: () -> Void = { return }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        leftBarButton.addTarget(self, action: #selector(handleLeftBarButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [leftBarButton, fakeSearchBar].forEach {
            addSubview($0)
        }
        
        leftBarButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        fakeSearchBar.snp.makeConstraints {
            $0.leading.equalTo(leftBarButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    // MARK: - Helpers
    func configureSearchNaviBar(leftBarButtonActionHandler: @escaping () -> Void) {
        self.leftBarButtonActionHandler = leftBarButtonActionHandler
    }
    
    
    // MARK: - Selectors
    @objc private func handleLeftBarButton(_ sender: UIButton) {
        leftBarButtonActionHandler()
    }
}
