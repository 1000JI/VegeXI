//
//  FilterViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/7/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    // MARK: - Properties
    let topBar = FilterViewTopBar()
    let filterTableView = UITableView(frame: .zero, style: .grouped)
    let bottomBar = FilterViewBottomBar(title: GeneralStrings.filterBottomViewTitle.generateString())
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
        filterTableView.allowsMultipleSelection = true
        filterTableView.separatorStyle = .none
        filterTableView.backgroundColor = .white
        
        topBar.configureTopBar(closeFilterAction: closeFilterView)
        bottomBar.configureBottomBar(filterActionHandler: applyFilter)
    }
    
    private func setConstraints() {
        [topBar, filterTableView, bottomBar].forEach {
            view.addSubview($0)
        }
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(70)
        }
        filterTableView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        bottomBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(75)
        }
    }
    
    
    // MARK: - Helpers
    private func closeFilterView() {
        print(#function)
    }
    
    private func applyFilter() {
        print(#function)
    }
    
}


// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    
    // Section
    func numberOfSections(in tableView: UITableView) -> Int {
        MockData.filterList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FilterTableViewHeader()
        if let text = MockData.filterList[section].keys.first {
            header.configureHeader(text: text)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let values = MockData.filterList[section].values.first else { return 0 }
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filterTableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else { fatalError("No Cell Info") }
        guard let key = MockData.filterList[indexPath.section].keys.first else { fatalError("No Cell Info") }
        guard let texts = MockData.filterList[indexPath.section][key] else { fatalError("No Cell Info") }
        let text = texts[indexPath.row]
        cell.configureCell(text: text)
        cell.selectionStyle = .none
        return cell
    }
}


// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = filterTableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        cell.handleDidSelected(selected: cell.isSelected)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = filterTableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        cell.handleDidSelected(selected: cell.isSelected)
    }
}
