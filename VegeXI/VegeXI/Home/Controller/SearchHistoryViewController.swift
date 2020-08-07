//
//  SearchFilterViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/6/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SearchHistoryViewController: UIViewController {

    // MARK: - Properties
    private let fakeSearchNaviBar = FakeSearchNaviBar()
    private let historyTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.rowHeight = 42
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }

    private func setConstraints() {
        [fakeSearchNaviBar, historyTableView].forEach {
            view.addSubview($0)
        }
        
        fakeSearchNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        historyTableView.snp.makeConstraints {
            $0.top.equalTo(fakeSearchNaviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setPropertyAttributes() {
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: SearchHistoryTableViewCell.identifier)
        
        fakeSearchNaviBar.fakeSearchBar.searchTextField.delegate = self
        fakeSearchNaviBar.configureSearchNaviBar(leftBarButtonActionHandler: handleLeftBackBarButton)
    }
    
    
    // MARK: - Helpers
    private func handleDeleteButton(cellNumber: Int) {
        removeData(index: cellNumber)
    }
    
    private func removeData(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        MockData.searchHistory.remove(at: index)
        historyTableView.deleteRows(at: [indexPath], with: .none)
        historyTableView.reloadData()
    }
    
    private func handleAllClearButton() {
        removeAllData()
    }
    
    private func removeAllData() {
        MockData.searchHistory.removeAll()
        historyTableView.reloadData()
    }
    
    private func handleLeftBackBarButton() {
        print(#function)
    }
}


// MARK: -  UITableViewDataSource
extension SearchHistoryViewController: UITableViewDataSource {
    
    // Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SearchHistoryHeaderView()
        header.configureHeader(clearButtonActionHandler: handleAllClearButton)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MockData.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: SearchHistoryTableViewCell.identifier, for: indexPath) as? SearchHistoryTableViewCell else { fatalError("No Cell Info") }
        let text = MockData.searchHistory[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(text: text, tag: indexPath.row, tapActionHandler: handleDeleteButton(cellNumber:))
        return cell
    }
}


// MARK: - UITableViewDelegate
extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = historyTableView.cellForRow(at: indexPath) as? SearchHistoryTableViewCell else { return }
        fakeSearchNaviBar.fakeSearchBar.currentText = cell.leftLable.text!
        fakeSearchNaviBar.fakeSearchBar.isSearching = fakeSearchNaviBar.fakeSearchBar.searchTextField.text != "" ? true : false
    }
}


// MARK: - UITextFieldDelegate
extension SearchHistoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        fakeSearchNaviBar.fakeSearchBar.isSearching = fakeSearchNaviBar.fakeSearchBar.searchTextField.text != "" ? true : false
    }
}
