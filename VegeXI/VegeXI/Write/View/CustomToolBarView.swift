//
//  CustomToolBarView.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class CustomToolBarView: UIView {
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private lazy var toolbar = UIToolbar().then {
        $0.barStyle = UIBarStyle.default
        $0.isTranslucent = false
        $0.tintColor = .vegeTextBlackColor
        $0.backgroundColor = .white
        
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
        
        $0.isUserInteractionEnabled = true
        $0.sizeToFit()
        $0.setItems([cameraButton, locationButton], animated: true)
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPink
        autoresizingMask = .flexibleHeight
        
        addSubview(toolbar)
        toolbar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
