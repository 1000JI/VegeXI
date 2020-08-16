//
//  UserProfileViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/17/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: UserProfileStrings.barTitle.rawValue)
    private let profileView = MyPageProfileView()
    private let separator = UIView().then {
        $0.backgroundColor = .vegeLightGrayButtonColor
    }
    private let postView = MyPageBookmarkView(isHidden: false)
    private lazy var postTableView = postView.postTableview
    private let mockData = MockData.postExample
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        isTabbarHidden(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabbarHidden(isHidden: false)
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleLeftBarButton(_:)), for: .touchUpInside)
        profileView.profileEditButton.isHidden = true

        postTableView.delegate = self
        postTableView.dataSource = self
    }
    
    private func setConstraints() {
        [topBarView, profileView, separator, postView].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(225)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        postView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleLeftBarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helpers
    
//    실제 데이터 연동 시 이곳을 주석해제하여 사용
//    private func configurePostTableViewDataSource(tableView: UITableView, indexPath: IndexPath) -> MyPageBookmarkableViewCell {
//        guard let cell = postTableView.dequeueReusableCell(withIdentifier: MyPageBookmarkableViewCell.identifier, for: indexPath) as? MyPageBookmarkableViewCell else { fatalError() }
//        let data = bookmarkFeeds[indexPath.row]
//        let title = data.title
//        let subtitle = data.content
//        let imageURL = data.imageUrls ?? [URL]()
//        let url = imageURL.count > 0 ? imageURL[0] : nil
//        let numberOfImages = data.imageUrls?.count ?? 0
//        let date = data.writeDate
//        let likes = data.likes
//        let comments = data.comments
//        let feedType = data.feedType
//        cell.configureCell(title: title, subtitle: subtitle, image: url, numberOfImages: numberOfImages, date: date, likes: likes, comments: comments, feedType: feedType)
//        return cell
//    }
    
    private func configurePostTableViewDataSourceWithMockData(tableView: UITableView, indexPath: IndexPath) -> MyPageBookmarkableViewCell {
        guard let cell = postTableView.dequeueReusableCell(withIdentifier: MyPageBookmarkableViewCell.identifier, for: indexPath) as? MyPageBookmarkableViewCell else { fatalError() }
        let data = mockData[indexPath.row]
        
        let imageURL = [URL]()
        guard let title = data["title"] as? String,
        let subtitle = data["subtitle"] as? String,
        let numberOfImages = data["numberOfImages"] as? Int,
        let likes = data["likes"] as? Int,
        let comments = data["comments"] as? Int
        else { fatalError() }
        let url = imageURL.count > 0 ? imageURL[0] : nil
        let date = data["date"] as? Date ?? Date()
        
        let feedType = FeedType.textType
        cell.configureCell(title: title, subtitle: subtitle, image: url, numberOfImages: numberOfImages, date: date, likes: likes, comments: comments, feedType: feedType)
        return cell
    }
    
}

extension UserProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //    실제 데이터 연동 시 이곳을 주석해제하여 사용
//        return configurePostTableViewDataSource(tableView: tableView, indexPath: indexPath)
        return configurePostTableViewDataSourceWithMockData(tableView: tableView, indexPath: indexPath)
    }
    
}

extension UserProfileViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyPageBookmarkableViewHeader()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
}
