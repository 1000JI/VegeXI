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
        didSet { detailHeaderView.feed = feed }
    }
    
    var firstEnter = true
    var comments = [Comment]() {
        didSet { detailTableView.reloadData() }
    }
    
    private let detailCustomBar = DetailCustomBar()
    private let detailTableView = UITableView(
        frame: .zero, style: .grouped)
    private lazy var detailHeaderView = DetailHeaderView().then {
        $0.tappedLikeButton = tappedLikeButton
        $0.tappedBookmarkButton = tappedBookmarkButton
        $0.tappedMoreButton = tappedMoreButton
    }
    private let nothingCommentLabel = UILabel().then {
        $0.text = "첫번째 댓글을 남겨주세요🥕"
        $0.textColor = .vegeTextBlackColor
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.textAlignment = .center
        $0.backgroundColor = .white
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
            
            if comments.count > 0 {
                self.showCommentRequestLabel(isShow: false)
            } else {
                self.showCommentRequestLabel(isShow: true)
            }
        }
    }
    
    
    // MARK: - Actions
    
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
        guard let uid = UserService.shared.user?.uid else { return }
        guard let feedWriterUid = feed?.writerUser.uid else { return }
        
        firstEnter = true
        if uid == feedWriterUid {
            showMoreWriterButtnAlert(
                viewController: self,
                editHandler: nil,
                linkCopyHandler: nil,
                shareHandler: nil,
                deleteHandler: nil)
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
                print("COMMENT UPLOAD SUCCESS")
                self.feed?.comments += 1
        }
    }
    
    
    // MARK: - Helpers
    
    func showCommentRequestLabel(isShow: Bool) {
        nothingCommentLabel.isHidden = !isShow
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        [detailCustomBar, detailTableView, nothingCommentLabel].forEach {
            view.addSubview($0)
        }
        
        detailCustomBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        detailTableView.snp.makeConstraints {
            $0.top.equalTo(detailCustomBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        nothingCommentLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureTableView() {
        detailTableView.backgroundColor = .white
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.separatorStyle = .none
        detailTableView.allowsSelection = false
        detailTableView.keyboardDismissMode = .interactive
        detailTableView.register(CommentTableViewCell.self,
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
            let commentsCount = comments.count - 1
            let indexPath = IndexPath(row: commentsCount, section: 0)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.comment = comments[indexPath.row]
        return cell
    }
}


// MARK: - UITableViewDelegate

extension FeedDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return detailHeaderView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 800
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // https://arcjeen.tistory.com/15
        return UITableView.automaticDimension
    }
}
