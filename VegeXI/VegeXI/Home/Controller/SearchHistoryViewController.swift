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
    var feeds: [Feed]?
    var searchFeeds = [Feed]() {
        didSet { mainTableView.feeds = searchFeeds }
    }
    
    private let fakeSearchNaviBar = FakeSearchNaviBar()
    private let historyTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.rowHeight = 42
    }
    
    private let categoryView = CategoryCollectionView().then {
        $0.isHidden = true
    }
    private let mainTableView = MainTableView(frame: .zero, style: .grouped).then {
        $0.isHidden = true
    }
    private let refreshControl = UIRefreshControl()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSearchTableView(isShow: false)
    }
    
    
    // MARK: - UI
    private func configureUI() {
        view.backgroundColor = .white
        setPropertyAttributes()
        setConstraints()
    }

    private func setConstraints() {
        [fakeSearchNaviBar, historyTableView, categoryView, mainTableView].forEach {
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
        categoryView.snp.makeConstraints {
            $0.top.equalTo(fakeSearchNaviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        mainTableView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
    private func showSearchTableView(isShow: Bool) {
        if isShow {
            historyTableView.isHidden = true
            categoryView.isHidden = false
            mainTableView.isHidden = false
        } else {
            historyTableView.isHidden = false
            categoryView.isHidden = true
            mainTableView.isHidden = true
            
            let indexPath = IndexPath(item: 0, section: 0)
            categoryView.collectionView.selectItem(
                at: indexPath,
                animated: false,
                scrollPosition: .centeredHorizontally)
            categoryView.collectionView(
                categoryView.collectionView,
                didSelectItemAt: indexPath)
        }
    }
    
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
        navigationController?.popViewController(animated: true)
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
        
        _ = textFieldShouldReturn(fakeSearchNaviBar.fakeSearchBar.searchTextField)
        
        fakeSearchNaviBar.fakeSearchBar.isSearching = fakeSearchNaviBar.fakeSearchBar.searchTextField.text != "" ? true : false
    }
}


// MARK: - UITextFieldDelegate
extension SearchHistoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        fakeSearchNaviBar.fakeSearchBar.isSearching = fakeSearchNaviBar.fakeSearchBar.searchTextField.text != "" ? true : false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.lowercased() else { return false }
        view.endEditing(true)
        
        if text.isEmpty {
            showSearchTableView(isShow: false)
        } else {
            showSearchTableView(isShow: true)
            
            guard let feeds = feeds else { return false }
            searchFeeds = feeds.filter {
                $0.title.lowercased().contains(text) ||
                    $0.content.lowercased().contains(text)
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        showSearchTableView(isShow: false)
        return true
    }
}
