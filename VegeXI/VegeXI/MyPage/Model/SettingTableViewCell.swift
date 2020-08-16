//
//  SettingTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "SettingTableViewCell"
    
    private lazy var titleStackView = UIStackView(arrangedSubviews: [cellTitle, cellSubtitle]).then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 0
    }
    private let cellTitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 15)
        $0.textColor = .vegeTextBlackColor
    }
    private let cellSubtitle = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 10)
        $0.textColor = .vegeCategoryTextColor
    }
    private let infoLabel = UILabel().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 15)
        $0.textColor = .buttonEnabledTextcolor
    }
    private let pager = UIImageView().then {
        let image = UIImage(named: "naviBar_BackBtnIcon")
        $0.image = image?.rotate(radians: .pi)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let switcher = UISwitch()
    var switchStatus: Bool {
        return switcher.isOn
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = .vegeLightGrayVegeInfoThinBar
    }
    
    private var cellType: SettingViewCellType = .defualt
    
    
    // MARK: - UI
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    // MARK: - UI
    private func configureUI() {
        setContraints()
    }
    
    private func setContraints() {
        [titleStackView, separator].forEach {
            self.addSubview($0)
        }
        titleStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        separator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        switch cellType {
        case .defualt:
            setConstraintsForDefualtType()
            break
        case .subtitlte:
            setConstraintsForSubtitlteType()
            break
        case .paging:
            setConstraintsForPagingType()
        case .switcher:
            setConstraintsForSwitcherType()
        case .info:
            setConstraintsForInfoType()
        }
    }
    
    private func setConstraintsForDefualtType() {

    }
    private func setConstraintsForSubtitlteType() {
        
    }
    private func setConstraintsForPagingType() {
        self.addSubview(pager)
        pager.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    private func setConstraintsForSwitcherType() {
        self.addSubview(switcher)
        switcher.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
    }
    private func setConstraintsForInfoType() {
        self.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    
    // MARK: - Methods
    func configureCell(title: String, subtitle: String?, info: String?, isOn: Bool, cellType: SettingViewCellType, separatorIsHidden: Bool) {
        cellTitle.text = title
        cellSubtitle.text = subtitle
        infoLabel.text = info
        switcher.isOn = isOn
        self.cellType = cellType
        self.separator.isHidden = separatorIsHidden
    }
    
}
