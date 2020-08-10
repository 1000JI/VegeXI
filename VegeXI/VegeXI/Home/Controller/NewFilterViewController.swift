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
    let bottomBar = FilterViewBottomBar()
    var selectedCells = [IndexPath]()
    
    
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
        filterTableView.register(NewFilterTableViewCell.self, forCellReuseIdentifier: NewFilterTableViewCell.identifier)
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.rowHeight = 134
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
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
        guard let cell = filterTableView.dequeueReusableCell(withIdentifier: NewFilterTableViewCell.identifier, for: indexPath) as? NewFilterTableViewCell else { fatalError("No Cell Info") }
        let key = MockData.newFilteredList[indexPath.section].first?.key ?? ""
        let data = MockData.newFilteredList[indexPath.section][key] ?? []
        cell.configureCell(data: data, delegateView: self)
        cell.filterCollectionView.reloadData()
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension NewFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}


// MARK: - UICollectionViewDelegate
extension NewFilterViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCells.contains(indexPath) == false {
            selectedCells.append(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if selectedCells.contains(indexPath) == true {
            guard let index = selectedCells.firstIndex(of: indexPath) else { return }
            selectedCells.remove(at: index)
        }
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout
extension NewFilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 81, height: 29)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }

}
