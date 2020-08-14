//
//  MyPageBookmarkView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit


class MyPageBookmarkView: UIView {
    
    // MARK: - Properties
    let postTableview = UITableView()
    private let mockData = MockData.postExample
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
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
        postTableview.register(MyPageBookmarkableViewCell.self, forCellReuseIdentifier: MyPageBookmarkableViewCell.identifier)
        postTableview.dataSource = self
        postTableview.delegate = self
        postTableview.rowHeight = 150
        postTableview.backgroundColor = .white
        postTableview.separatorStyle = .none
        postTableview.showsVerticalScrollIndicator = false
    }
    
    private func setConstraints() {
        [postTableview].forEach {
            self.addSubview($0)
        }
        postTableview.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
}


// MARK: - UITableViewDataSource
extension MyPageBookmarkView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = postTableview.dequeueReusableCell(withIdentifier: MyPageBookmarkableViewCell.identifier, for: indexPath) as? MyPageBookmarkableViewCell else { fatalError() }
        let data = mockData[indexPath.row]
        guard
            let title = data["title"] as? String,
            let subtitle = data["subtitle"] as? String,
            let imageName = data["image"] as? String,
            let numberOfImages = data["numberOfImages"] as? Int,
            let date = data["date"] as? String,
            let likes = data["likes"] as? Int,
            let comments = data["comments"] as? Int
            else { fatalError() }
        let feedType: FeedType = imageName == "" ? .textType : .picAndTextType
        let image = imageName != "" ? UIImage(named: imageName) ?? UIImage() : UIImage()
        cell.configureCell(title: title, subtitle: subtitle, image: image, numberOfImages: numberOfImages, date: date, likes: likes, comments: comments, feedType: feedType)
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension MyPageBookmarkView: UITableViewDelegate {
    
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

