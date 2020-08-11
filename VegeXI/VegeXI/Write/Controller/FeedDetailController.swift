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
    
    private let detailCustomBar = DetailCustomBar()
    private let detailTableView = UITableView(
        frame: .zero, style: .grouped)
    private let detailHeaderView = DetailHeaderView()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
        isTabbarHidden(isHidden: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isTabbarHidden(isHidden: false)
    }
    
    
    // MARK: - Actions
    
    func tappedBackButton() {
        navigationController?.popViewController(animated: true)
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
        detailTableView.register(CommentTableViewCell.self,
                                 forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    func configureEvent() {
        detailCustomBar.tappedBackButton = tappedBackButton
        
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
    
    /*
     https://stackoverflow.com/questions/46282987/iphone-x-how-to-handle-view-controller-inputaccessoryview
     https://developer-fury.tistory.com/46
     */
}


// MARK: - UITableViewDataSource

extension FeedDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension FeedDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return detailHeaderView
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 700
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // https://arcjeen.tistory.com/15
        return UITableView.automaticDimension
    }
}
