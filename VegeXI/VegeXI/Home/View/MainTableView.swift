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
    
    var isFilterFeeds = false
    var viewType: ViewType = .home
    
    var recentFeeds = [Feed]() {
        didSet {
            isFilterFeeds = false
            sortTitleLabel.text = "최신순"
            reloadData()
        }
    }
    
    var popularFeeds = [Feed]() {
        didSet {
            isFilterFeeds = true
            sortTitleLabel.text = "인기순"
            reloadData()
        }
    }
    
    private let headerViewHeight: CGFloat = 56
    private let textCellHeight: CGFloat = 168
    private let picAndTextCellHeight: CGFloat = 500
    
    private let sortTitleLabel = UILabel()
    private let sortImageView = UIImageView()
    private lazy var sortStack = makeFilterView(
        filterLabel: sortTitleLabel,
        filterName: "최신순",
        filterImageView: sortImageView,
        imageName: "feed_DownButton")
    
    private let filterTitleLabel = UILabel()
    private let filterImageView = UIImageView()
    private lazy var filterStack = makeFilterView(
        filterLabel: filterTitleLabel,
        filterName: "필터",
        filterImageView: filterImageView,
        imageName: "feed_PlusButton")
    
    var handleSortTapped: (() -> Void)?
    var handleFilterTapped: (() -> Void)?
    var handleCommentTapped: ((Feed) -> Void)?
    
    private lazy var headerView = UIView().then {
        $0.backgroundColor = .white
        
        let sortTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedSortButton))
        sortStack.addGestureRecognizer(sortTapGesture)
        
        let filterTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedFilterButton))
        filterStack.addGestureRecognizer(filterTapGesture)
        
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
    
    init(viewType: ViewType) {
        super.init(frame: .zero, style: .grouped)
        self.viewType = viewType
        configureTableView()
        
        if viewType == .search {
            filterStack.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Seletors
    
    @objc func tappedSortButton() {
        handleSortTapped?()
    }
    
    @objc func tappedFilterButton() {
        handleFilterTapped?()
    }
    
    // MARK: - Action
    
    func tappedLikeButton(cell: MainTableViewCell) {
        guard let feed = cell.feed else { return }
        
        FeedService.shared.likeFeed(feed: feed) { (error, ref) in
            cell.feed?.didLike.toggle()
            let likes = feed.didLike ? feed.likes - 1 : feed.likes + 1
            cell.feed?.likes = likes
            
            let row = self.indexPath(for: cell)!.row
            self.recentFeeds[row].didLike = cell.feed?.didLike ?? false
            self.recentFeeds[row].likes = cell.feed?.likes ?? 0
        }
        
    }
    
    func tappedCommentButton(cell: MainTableViewCell) {
        guard let feed = cell.feed else { return }
        handleCommentTapped?(feed)
    }
    
    func tappedBookmarkButton(cell: MainTableViewCell) {
        guard let feed = cell.feed else { return }
        
        FeedService.shared.bookmarkFeed(feed: feed) { (error, ref) in
            if let error = error {
                print("DEBUG: Bookmark Tapped Error \(error.localizedDescription)")
            }
            
            cell.feed?.didBookmark.toggle()
            
            let row = self.indexPath(for: cell)!.row
            self.recentFeeds[row].didBookmark = cell.feed?.didBookmark ?? false
        }
    }
    
    
    // MARK: - Helpers
    
    func configureTableView() {
        backgroundColor = .white
        separatorStyle = .none
        allowsSelection = true
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
        return isFilterFeeds ? popularFeeds.count : recentFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.feed = isFilterFeeds ?
            popularFeeds[indexPath.row] : recentFeeds[indexPath.row]
        cell.tappedLikeButton = tappedLikeButton(cell:)
        cell.tappedCommentButton = tappedCommentButton(cell:)
        cell.tappedBookmarkButton = tappedBookmarkButton(cell:)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension MainTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFilterFeeds {
            return popularFeeds[indexPath.row].feedType == .textType ?
            textCellHeight : picAndTextCellHeight
        } else {
            return recentFeeds[indexPath.row].feedType == .textType ?
            textCellHeight : picAndTextCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MainTableViewCell
        guard let feed = cell.feed else { return }
        handleCommentTapped?(feed)
        tableView.selectRow(at: nil, animated: false, scrollPosition: .none)
    }
}
