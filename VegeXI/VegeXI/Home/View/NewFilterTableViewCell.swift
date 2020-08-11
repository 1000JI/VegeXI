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
        let flowLayout = AlignedCollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.horizontalAlignment = .leading
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    private let infoImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
        $0.image = UIImage(named: "VegeInfo")
    }
    
    private var collectionViewData: [String] = []
    private var cellTag = 0
    
    private var selectedCells = Set<IndexPath>()
    private var saveSelectedCellInfo: (Int, IndexPath) -> Void = { _, _ in return }
    private var deleteSelectedCellInfo: (Int, IndexPath) -> Void = { _, _ in return }
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cellTag == 0 {
            addSubview(infoImageView)
            infoImageView.snp.makeConstraints {
                $0.top.equalTo(filterCollectionView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(26)
            }
        }
    }

    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.allowsMultipleSelection = true
        filterCollectionView.isScrollEnabled = false
        filterCollectionView.backgroundColor = .white
    }
    
    private func setConstraints() {
        addSubview(filterCollectionView)
        filterCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
    
    
    // MARK: - Helpers
    func configureCell(
        data: [String],
        tag: Int,
        selectedCells: Set<IndexPath>,
        savingDataMethod: @escaping (Int, IndexPath) -> Void,
        deletingDataMethod: @escaping (Int, IndexPath) -> Void) {
        collectionViewData = data
        cellTag = tag
        self.selectedCells = selectedCells
        saveSelectedCellInfo = savingDataMethod
        deleteSelectedCellInfo = deletingDataMethod
    }
    
    func getTextSize(indexPath: IndexPath) -> CGSize {
        let text = collectionViewData[indexPath.item]
        let font = UIFont.spoqaHanSansRegular(ofSize: 13)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
    }
    
    func checkSelectionStatus(cell: FilterCollectionViewCell, indexPath: IndexPath) {
        if selectedCells.contains(indexPath) {
            cell.isClicked = true
            cell.configureSelectedEffects(selected: true)
        } else {
            cell.configureSelectedEffects(selected: false)
        }
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
        checkSelectionStatus(cell: cell, indexPath: indexPath)
        return cell
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout
extension NewFilterTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 26
        let width = getTextSize(indexPath: indexPath).width + padding
        return CGSize(width: width, height: 29)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
}


// MARK: - UICollectionViewDelegate
extension NewFilterTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = filterCollectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        saveSelectedCellInfo(cellTag, indexPath)
        cell.isClicked.toggle()
        if cell.isClicked == false {
            deleteSelectedCellInfo(cellTag, indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = filterCollectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        deleteSelectedCellInfo(cellTag, indexPath)
        cell.isClicked.toggle()
        if cell.isClicked == true {
            saveSelectedCellInfo(cellTag, indexPath)
        }
    }
    
}
