//
//  MainTableView.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/06.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MainTableView: UITableView {
    
    // MARK: - Properties
    
    var feeds = [Feed]() {
        didSet { reloadData() }
    }
    
    private let headerViewHeight: CGFloat = 56
    private let cellHeight: CGFloat = 500
    
    private let sortTitleLabel = UILabel()
    private let sortImageView = UIImageView()
    
    private let filterTitleLabel = UILabel()
    private let filterImageView = UIImageView()
    
    private lazy var headerView = UIView().then {
        $0.backgroundColor = .white
        
        let sortStack = makeFilterView(
            filterLabel: sortTitleLabel,
            filterName: "최신순",
            filterImageView: sortImageView,
            imageName: "feed_DownButton")
        
        let filterStack = makeFilterView(
            filterLabel: filterTitleLabel,
            filterName: "필터",
            filterImageView: filterImageView,
            imageName: "feed_PlusButton")
        
        $0.addSubview(sortStack)
        $0.addSubview(filterStack)
        
        sortStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        filterStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        backgroundColor = .white
        separatorStyle = .none
        allowsSelection = false
        dataSource = self
        delegate = self
        
        register(MainTableViewCell.self,
                 forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    func makeFilterView(filterLabel: UILabel, filterName: String, filterImageView: UIImageView, imageName: String) -> UIStackView {
        filterLabel.text = filterName
        filterLabel.textColor = .vegeTextBlackColor
        filterLabel.font = UIFont.spoqaHanSansRegular(ofSize: 13)
        
        filterImageView.image = UIImage(named: imageName)
        filterImageView.contentMode = .scaleAspectFill
        filterImageView.tintColor = .vegeTextBlackColor
        filterImageView.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        let stack = UIStackView(arrangedSubviews: [filterLabel, filterImageView])
        stack.axis = .horizontal
        
        return stack
    }
}


// MARK: - UITableViewDataSource

extension MainTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension MainTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewHeight
    }
}
