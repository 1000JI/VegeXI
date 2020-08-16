//
//  EditProfileSelectTypeView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class EditProfileSelectTypeView: UIView {
    
    // MARK: - Properties
    private let viewTitle = UILabel().then {
        $0.text = EditProfileStrings.vegeType.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 16)
        $0.textColor = .vegeTextBlackColor
    }
    let vegeTypeTableView = UITableView()
    var tableViewCells = [EditProfileTypeTableViewCell]()
    private let data = MockData.editProfileVegeTypes
    var selectedType = "지향없음" {
        didSet { vegeTypeTableView.reloadData() }
    }
    
    
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
        vegeTypeTableView.register(EditProfileTypeTableViewCell.self, forCellReuseIdentifier: EditProfileTypeTableViewCell.identifier)
        vegeTypeTableView.dataSource = self
        vegeTypeTableView.rowHeight = 44
        vegeTypeTableView.isScrollEnabled = false
        vegeTypeTableView.separatorStyle = .none
    }
    
    private func setConstraints() {
        [viewTitle, vegeTypeTableView].forEach {
            self.addSubview($0)
        }
        viewTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        vegeTypeTableView.snp.makeConstraints {
            $0.top.equalTo(viewTitle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureTableViewCells(cell: EditProfileTypeTableViewCell, title: String, imageName: String, indexPath: IndexPath) {
        cell.selectionStyle = .none
        var isSelected = false
        isSelected = title == selectedType ? true : false
        if indexPath.row == data.count - 1 {
            cell.configureCell(title: title, imageName: imageName, isSelected: isSelected, separatorAlpha: 0)
        } else {
            cell.configureCell(title: title, imageName: imageName, isSelected: isSelected, separatorAlpha: 1)
        }
        tableViewCells.append(cell)
    }
    
}


extension EditProfileSelectTypeView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = vegeTypeTableView.dequeueReusableCell(withIdentifier: EditProfileTypeTableViewCell.identifier, for: indexPath) as? EditProfileTypeTableViewCell else { fatalError() }
        guard let title = data[indexPath.row]["title"] else { fatalError() }
        guard let imageName = data[indexPath.row]["image"] else { fatalError() }
        configureTableViewCells(cell: cell, title: title, imageName: imageName, indexPath: indexPath)
        return cell
    }
    
}
