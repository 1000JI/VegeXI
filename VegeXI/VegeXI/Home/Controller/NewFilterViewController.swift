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
    typealias IndexPathSet = Set<IndexPath>
    private let topBar = FilterViewTopBar()
    private let filterTableView = UITableView(frame: .zero, style: .grouped)
    private let bottomBar = FilterViewBottomBar(title: GeneralStrings.filterBottomViewTitle.generateString())
    
    private var selectedCells: [Int: IndexPathSet] = [:] {
        willSet {
            print(newValue)
        }
    }
    
    private var selectedVegeType = [VegeType]() // 선택된 채식타입을 저장
    private var selectedCategoryTitle = [CategoryType]() // 선택된 카테고리 타이틀을 저장
    private var selectedFilters = [PostCategory]() // 선택된 카테고리를 저장
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        configureVegeType(selectedCellInfo: selectedCells)
        configureCategoryTitle(selectedCellInfo: selectedCells)
        configureCategory(selectedCellInfo: selectedCells)
        print(selectedVegeType)
        print(selectedCategoryTitle)
        print(selectedFilters)
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
    
    private func configureVegeType(selectedCellInfo: [Int: IndexPathSet]) {
        selectedVegeType.removeAll()
        guard let selectedVegeTypes = selectedCellInfo[0] else { return }
        for selectedVegeType in selectedVegeTypes {
            switch selectedVegeType.row {
            case 0:
                self.selectedVegeType.append(.nothing)
            case 1:
                self.selectedVegeType.append(.vegan)
            case 2:
                self.selectedVegeType.append(.ovo)
            case 3:
                self.selectedVegeType.append(.lacto)
            case 4:
                self.selectedVegeType.append(.lacto_ovo)
            case 5:
                self.selectedVegeType.append(.pesco)
            default:
                break
            }
        }
    }
    
    private func configureCategoryTitle(selectedCellInfo: [Int: IndexPathSet]) {
        selectedCategoryTitle.removeAll()
        for index in 1...4 {
            guard let selectedFilters = selectedCellInfo[index] else { continue }
            guard selectedFilters.count > 0 else { continue }
            switch index {
            case 1:
                selectedCategoryTitle.append(.diet)
            case 2:
                selectedCategoryTitle.append(.location)
            case 3:
                selectedCategoryTitle.append(.product)
            case 4:
                selectedCategoryTitle.append(.content)
            default:
                break
            }
        }
    }
    
    private func configureCategory(selectedCellInfo: [Int: IndexPathSet]) {
        self.selectedFilters.removeAll()
        for index in 1...4 {
            guard let selectedFilters = selectedCellInfo[index] else { continue }
            for filter in selectedFilters {
                switch index {
                case 1:
                    switch filter {
                    case [0, 0]:
                        self.selectedFilters.append(.koreanFood)
                    case [0, 1]:
                        self.selectedFilters.append(.snackBar)
                    case [0, 2]:
                        self.selectedFilters.append(.japaneseFood)
                    case [0, 3]:
                        self.selectedFilters.append(.chineseFood)
                    case [0, 4]:
                        self.selectedFilters.append(.westernFood)
                    case [0, 5]:
                        self.selectedFilters.append(.eastAsianFood)
                    case [0, 6]:
                        self.selectedFilters.append(.indianFood)
                    case [0, 7]:
                        self.selectedFilters.append(.breadAndCoffee)
                    case [0, 8]:
                        self.selectedFilters.append(.alcohol)
                    default:
                        break
                    }
                case 2:
                    switch filter {
                    case [0, 0]:
                        self.selectedFilters.append(.restuarant)
                    case [0, 1]:
                        self.selectedFilters.append(.bakeryAndCafe)
                    case [0, 2]:
                        self.selectedFilters.append(.houseHoldGoodsStore)
                    case [0, 3]:
                        self.selectedFilters.append(.Exhibition)
                    default:
                        break
                    }
                case 3:
                    switch filter {
                    case [0, 0]:
                        self.selectedFilters.append(.cosmetics)
                    case [0, 1]:
                        self.selectedFilters.append(.houseHoldGoods)
                    case [0, 2]:
                        self.selectedFilters.append(.fashion)
                    default:
                        break
                    }
                case 4:
                    switch filter {
                    case [0, 0]:
                        self.selectedFilters.append(.influencer)
                    case [0, 1]:
                        self.selectedFilters.append(.book)
                    case [0, 2]:
                        self.selectedFilters.append(.movie)
                    case [0, 3]:
                        self.selectedFilters.append(.documentary)
                    default:
                        break
                    }
                    
                default:
                    break
                }
            }
        }
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

}
