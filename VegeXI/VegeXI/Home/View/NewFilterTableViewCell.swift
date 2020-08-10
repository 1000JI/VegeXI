//
//  NewFilterTableViewCell.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/10/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class NewFilterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "NewFilterTableViewCell"
    
    lazy var filterCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    var collectionViewData: [String] = []
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        filterCollectionView.dataSource = self
        filterCollectionView.backgroundColor = .white
        filterCollectionView.allowsMultipleSelection = true
    }
    
    private func setConstraints() {
        addSubview(filterCollectionView)
        filterCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Helpers
    func configureCell(data: [String], delegateView: UICollectionViewDelegate) {
        collectionViewData = data
        filterCollectionView.delegate = delegateView
    }
    
}


// MARK: - UICollectionViewDataSource
extension NewFilterTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { fatalError("No Cell Info") }
        let data = collectionViewData[indexPath.row]
        cell.configureCell(title: data)
        return cell
    }
    
}


