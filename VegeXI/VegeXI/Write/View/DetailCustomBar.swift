//
//  DetailCustomBar.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/10.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

class DetailCustomBar: UIView {
    
    // MARK: - Properties
    
    private lazy var backButton = makeButton(imageName: "naviBar_BackBtnIcon")
    
    var tappedBackButton: (() -> ())?
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleButtonEvent(_ sender: UIButton) {
        switch sender {
        case backButton:
            tappedBackButton?()
        default:
            return
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func makeButton(imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleButtonEvent), for: .touchUpInside)
        button.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        return button
    }
}
