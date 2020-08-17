//
//  FeedDetailController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/10.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FeedDetailController: UIViewController {
    
    // MARK: - Properties
    
    var feed: Feed? {
        didSet {
            detailHeaderView.feed = feed
            detailTableView.reloadData()
        }
    }
    
    var firstEnter = true
    var comments = [Comment]() {
        didSet { detailTableView.reloadData() }
    }
    
    private let detailCustomBar = DetailCustomBar()
    private let detailTableView = UITableView(
        frame: .zero, style: .grouped)
    private lazy var detailHeaderView = DetailHeaderView().then {
        $0.tappedMoreButton = tappedMoreButton
    }
    
    private lazy var customInputView = CustomInputAccessoryView(frame:
        CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureEvent()
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
        isTabbarHidden(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabbarHidden(isHidden: false)
    }
    
    // MARK: - API
    
    func fetchComments() {
        guard let feed = feed else { return }
        
        showLoader(true)
        FeedService.shared.fetchComments(feedID: feed.feedID) { comments in
            self.comments = comments
            self.showLoader(false)
            self.tableViewNewCommentMove()
        }
    }
    
    
    // MARK: - Actions
    
    func tappedLocationButton(location: LocationModel) {
//        kakaomap://look?p=37.537229,127.005515
//        let url = URL(string: "kakaomap://look?p=\(location.latitude),\(location.longitude)")
        let url = URL(string: "kakaomap://place?id=\(location.id)")
        if let appUrl = url {
            if UIApplication.shared.canOpenURL(appUrl) {
                UIApplication.shared.open(appUrl,
                                          options: [:],
                                          completionHandler: nil)
            }
        } else {
            //https://apps.apple.com/us/app/id304608425
            let appStoreURL = URL(string: "https://apps.apple.com/us/app/id304608425")!
            UIApplication.shared.open(appStoreURL,
                                      options: [:])
        }
    }
    
    func tappedLikeButton() {
        guard let feed = feed else { return }
        
        FeedService.shared.likeFeed(feed: feed) { (error, ref) in
            let likes = feed.didLike ? feed.likes - 1 : feed.likes + 1
            self.feed?.didLike.toggle()
            self.feed?.likes = likes
        }
    }
    
    func tappedBookmarkButton() {
        guard let feed = feed else { return }
        FeedService.shared.bookmarkFeed(feed: feed) { (error, ref) in
            if let error = error {
                print("DEBUG: Bookmark Tapped Error \(error.localizedDescription)")
                return
            }
            self.feed?.didBookmark.toggle()
        }
    }
    
    func tappedMoreButton() {
        guard let user = UserService.shared.user else { return }
        guard let feed = feed else { return }
        
        firstEnter = true
        if user.uid == feed.writerUser.uid {
            showMoreWriterButtnAlert(
                viewController: self,
                editHandler: nil,
                linkCopyHandler: nil,
                shareHandler: nil,
                deleteHandler: { ACTION in
                    
            })
        } else {
            showMoreBasicButtnAlert(
                viewController: self,
                reportHandler: nil,
                linkCopyHandler: nil,
                shareHandler: nil)
        }
    }
    
    func tappedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func insertCommentText(caption: String) {
        guard let feed = feed else { return }
        firstEnter = false
        
        FeedService.shared.uploadComment(
            caption: caption,
            feed: feed) { (error, ref) in
                if let error = error {
                    print("DEBUG: COMMENT ERROR \(error.localizedDescription)")
                    return
                }
                self.feed?.comments += 1
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        [detailCustomBar, detailTableView].forEach {
            view.addSubview($0)
        }
        
        detailCustomBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        detailTableView.snp.makeConstraints {
            $0.top.equalTo(detailCustomBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureTableView() {
        detailTableView.backgroundColor = .white
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.separatorStyle = .none
        detailTableView.allowsSelection = false
        detailTableView.keyboardDismissMode = .interactive
        detailTableView.tableFooterView = UIView()
        detailTableView.sectionFooterHeight = 0
        detailTableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 35, right: 0)
        
        detailTableView.register(
            DetailTitleTableCell.self,
            forCellReuseIdentifier: DetailTitleTableCell.identifer)
        detailTableView.register(
            DetailMapTableCell.self,
            forCellReuseIdentifier: DetailMapTableCell.identifer)
        detailTableView.register(
            DetailImageTableCell.self,
            forCellReuseIdentifier: DetailImageTableCell.identifer)
        detailTableView.register(
            DetailContentTableCell.self,
            forCellReuseIdentifier: DetailContentTableCell.identifer)
        detailTableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    func configureEvent() {
        detailCustomBar.tappedBackButton = tappedBackButton
        customInputView.insertCommentText = insertCommentText(caption:)
        
        keyboardWillShowNotification { notification in
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
                let keybaordRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keybaordRectangle.height
                let inputAccessoryHeight = self.inputAccessoryView!.frame.height
                let amountHeight = keyboardHeight - inputAccessoryHeight
                
                self.detailTableView.snp.removeConstraints()
                self.detailTableView.snp.makeConstraints {
                    $0.top.equalTo(self.detailCustomBar.snp.bottom)
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-amountHeight)
                }
                
                DispatchQueue.main.async {
                    self.tableViewNewCommentMove()
                }
            }
        }
        
        keyboardWillHideNotification { notification in
            self.detailTableView.snp.removeConstraints()
            self.detailTableView.snp.makeConstraints {
                $0.top.equalTo(self.detailCustomBar.snp.bottom)
                $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    func configureNavi() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func tableViewNewCommentMove() {
        if !self.firstEnter {
            guard comments.count > 0 else { return }
            print(#function, comments.count)
            let commentsCount = comments.count - 1
            let section = FeedDetailSection.comment.rawValue
            let indexPath = IndexPath(row: commentsCount, section: section)
            detailTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    /*
     https://stackoverflow.com/questions/46282987/iphone-x-how-to-handle-view-controller-inputaccessoryview
     https://developer-fury.tistory.com/46
     */
}


// MARK: - UITableViewDataSource

extension FeedDetailController: UITableViewDataSource {
    enum FeedDetailSection: Int, CaseIterable {
        case title
        case map
        case image
        case content
        case comment
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FeedDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FeedDetailSection(rawValue: section)! {
        case .title: fallthrough
        case .content: return 1
        case .map: return feed?.location != nil ? 1 : 0
        case .image: return feed?.imageUrls != nil ? 1 : 0
        case .comment: return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch FeedDetailSection(rawValue: indexPath.section)! {
        case .title:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailTitleTableCell.identifer,
                for: indexPath) as! DetailTitleTableCell
            cell.titleTextView.text = feed?.title
            return cell
        case .map:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailMapTableCell.identifer,
                for: indexPath) as! DetailMapTableCell
            cell.location = feed?.location
            cell.tappedLocationEvent = tappedLocationButton(location:)
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailImageTableCell.identifer,
                for: indexPath) as! DetailImageTableCell
            cell.imageUrlArray = feed!.imageUrls!
            return cell
        case .content:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailContentTableCell.identifer,
                for: indexPath) as! DetailContentTableCell
            cell.tappedBookmarkButton = tappedBookmarkButton
            cell.tappedLikeButton = tappedLikeButton
            cell.feed = feed
            return cell
        case .comment:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
            cell.comment = comments[indexPath.row]
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension FeedDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? detailHeaderView : nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // https://arcjeen.tistory.com/15
        return 44
    }
}
