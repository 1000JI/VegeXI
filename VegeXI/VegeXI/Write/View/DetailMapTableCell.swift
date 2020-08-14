//
//  DetailMapTableCell.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/14.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class DetailMapTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifer = "DetailMapTableCell"
    
    var location: LocationModel? {
        didSet { configure() }
    }
    
    var tappedLocationEvent: ((LocationModel) -> ())?
    
    private lazy var locationIcon = UIImageView().then {
        $0.image = UIImage(named: "write_Location_Green_Icon")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedLocationButton))
        $0.addGestureRecognizer(gesture)
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var locationLabel = UILabel().then {
        $0.text = "위치"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 13)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedLocationButton))
        $0.addGestureRecognizer(gesture)
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Seletors
    
    @objc
    func tappedLocationButton() {
        guard let location = location else { return }
        tappedLocationEvent?(location)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        [locationIcon, locationLabel].forEach {
            addSubview($0)
        }
        
        locationIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIcon.snp.trailing).offset(-4)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure() {
        guard let location = location else { return }
        locationLabel.text = location.placeName
    }
}
