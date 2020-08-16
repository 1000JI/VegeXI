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
    
    private var isRecent = true // false => popular
    private var isApplyCategory: Bool {
        return filterFeeds.count != 0
    }
    var amountFeeds = [Feed]() {
        didSet { configureFeeds(feeds: amountFeeds) }
    }
    private var filterFeeds = [Feed]() {
        didSet { configureFeeds(feeds: filterFeeds) }
    }
    
    var searchFeeds = [Feed]() {
        didSet { mainTableView.recentFeeds = searchFeeds }
    }
    var searchFilterFeeds = [Feed]() {
        didSet { mainTableView.popularFeeds = searchFilterFeeds }
    }
    var histories = [String]() {
        didSet { historyTableView.reloadData() }
    }
    
    private let fakeSearchNaviBar = FakeSearchNaviBar()
    private let historyTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.rowHeight = 42
    }
    
    private let categoryView = CategoryCollectionView().then {
        $0.isHidden = true
    }
    private lazy var mainTableView = MainTableView(viewType: .search).then {
        $0.isHidden = true
        $0.handleCommentTapped = tappedCommentEvent(feed:)
        $0.handleSortTapped = tappedSortEvent
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchHistoryList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fakeSearchNaviBar.fakeSearchBar.isSearching {
            showSearchTableView(isShow: true)
        } else {
            showSearchTableView(isShow: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isTabbarHidden(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabbarHidden(isHidden: false)
    }
    
    // MARK: - API
    func fetchHistoryList() {
        FeedService.shared.fetchHistories { histories in
            self.histories = histories
        }
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
        categoryView.tappedCategory = tappedCategory(category:)
    }
    
    // MARK: - Actions
    func tappedCategory(category: String) {
        self.isRecent = true
        if category == "전체" {
            filterFeeds.removeAll()
            configureFeeds(feeds: searchFeeds)
        } else {
            filterFeeds = searchFeeds.filter {
                $0.category.categoryTitleType.rawValue == category
            }
        }
    }
    
    func tappedSortEvent() {
        let sortAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let newestSortAction = UIAlertAction(
            title: "최신순",
            style: .default) { action in
                self.isRecent = true
                self.filterFeeds = self.isApplyCategory ?
                    self.filterFeeds.sorted(by: { lhs, rhs -> Bool in
                        lhs.writeDate > rhs.writeDate
                    })
                    :
                    self.searchFeeds.sorted(by: { lhs, rhs -> Bool in
                        lhs.writeDate > rhs.writeDate
                    })
        }
        let popularSortAction = UIAlertAction(
            title: "인기순",
            style: .default) { action in
                self.isRecent = false
                self.filterFeeds = self.isApplyCategory ?
                    self.filterFeeds.sorted(by: { lhs, rhs -> Bool in
                        lhs.likes > rhs.likes
                    })
                    :
                    self.searchFeeds.sorted(by: { lhs, rhs -> Bool in
                        lhs.likes > rhs.likes
                    })
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil)
        sortAlert.addAction(newestSortAction)
        sortAlert.addAction(popularSortAction)
        sortAlert.addAction(cancelAction)
        sortAlert.view.tintColor = .vegeTextBlackColor
        
        present(sortAlert, animated: true)
    }
    
    
    // MARK: - Helpers
    
    func configureFeeds(feeds: [Feed]) {
        if isRecent {
            mainTableView.recentFeeds = feeds
        } else {
            mainTableView.popularFeeds = feeds
        }
    }
    
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
    
    // MARK: - Actions
    
    private func tappedCommentEvent(feed: Feed) {
        let controller = FeedDetailController()
        controller.feed = feed
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func handleDeleteButton(cellNumber: Int) {
        removeData(index: cellNumber)
    }
    
    private func removeData(index: Int) {
        let keyword = histories[index]
        showLoader(true)
        FeedService.shared.removeHistory(keyword: keyword) { (error, ref) in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Remove History error \(error.localizedDescription)")
                return
            }
            print("DEBUG: History Remove Success")
            self.histories.remove(at: index)
        }
    }
    
    private func handleAllClearButton() {
        FeedService.shared.allRemoveHistories { (error, ref) in
            if let error = error {
                print("DEBUG: Remove History error \(error.localizedDescription)")
                return
            }
            print("DEBUG: History All Remove Success")
            self.histories.removeAll()
        }
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
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: SearchHistoryTableViewCell.identifier, for: indexPath) as? SearchHistoryTableViewCell else { fatalError("No Cell Info") }
        let text = histories[indexPath.row]
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
        
        let keyword = fakeSearchNaviBar.fakeSearchBar.searchTextField
        _ = textFieldShouldReturn(keyword)
        
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
            
            let keyword = text.trimmingCharacters(in: [".", "#", "$", "[", "]"])
            var isNewKeyword = true
            if self.histories.contains(keyword) { isNewKeyword = false }
            if isNewKeyword {
                FeedService.shared.uploadHistoryKeyword(keyword: keyword) { (error, ref) in
                    if let error = error {
                        print("DEBUG: History Upload Error \(error.localizedDescription)")
                        return
                    }
                    print("DEBUG: History Save Success")
                    self.histories.append(keyword)
                }
            }
            
            self.isRecent = true
            searchFeeds = amountFeeds.filter {
                $0.title.lowercased().contains(keyword) ||
                    $0.content.lowercased().contains(keyword)
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        showSearchTableView(isShow: false)
        return true
    }
}
