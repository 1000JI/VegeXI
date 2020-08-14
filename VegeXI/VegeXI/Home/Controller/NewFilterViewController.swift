//
//  NewFilterViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/10/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class NewFilterViewController: UIViewController {
    
    // MARK: - Properties
    let topBar = FilterViewTopBar()
    let filterTableView = UITableView(frame: .zero, style: .grouped)
    let bottomBar = FilterViewBottomBar(title: GeneralStrings.filterBottomViewTitle.generateString())
    typealias setIndexPath = Set<IndexPath>
    
    var selectedCells: [Int: setIndexPath] = [:] {
        willSet {
            print(newValue)
        }
    }
    
    
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
        filterTableView.separatorStyle = .none
        filterTableView.backgroundColor = .white
        filterTableView.showsVerticalScrollIndicator = false
        
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
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.equalTo(bottomBar.snp.top)
        }
        bottomBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(75)
        }
    }
    
    
    // MARK: - Helpers
    private func closeFilterView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func applyFilter() {
        print(#function)
    }
    
    private func saveSelectionData(cellTag: Int, indexPath: IndexPath) {
        if selectedCells[cellTag] == nil {
            selectedCells[cellTag] = [indexPath]
        } else {
            selectedCells[cellTag]?.insert(indexPath)
        }
    }
    
    private func deleteSelectionData(cellTag: Int, indexPath: IndexPath) {
        guard let index = selectedCells[cellTag]?.firstIndex(of: indexPath) else { return }
        selectedCells[cellTag]?.remove(at: index)
    }
    
}


// MARK: - UITableViewDataSource
extension NewFilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MockData.newFilteredList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FilterTableViewHeader()
        let text = MockData.newFilteredList[section].first?.key ?? "Error"
        header.configureHeader(text: text)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewFilterTableViewCell()
        let key = MockData.newFilteredList[indexPath.section].first?.key ?? ""
        let data = MockData.newFilteredList[indexPath.section][key] ?? []
        cell.configureCell(
            data: data,
            tag: indexPath.section,
            selectedCells: selectedCells[indexPath.section] ?? [],
            savingDataMethod: saveSelectionData(cellTag:indexPath:),
            deletingDataMethod: deleteSelectionData(cellTag:indexPath:)
        )
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 303
        case 1,2:
            return 134
        case 3,4:
            return 100
        default:
            print("No Cell Height Info")
            return 134
        }
    }
    
}


// MARK: - UITableViewDelegate
extension NewFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
