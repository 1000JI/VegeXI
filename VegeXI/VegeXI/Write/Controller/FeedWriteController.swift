//
//  FeedWriteControllerr.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class FeedWriteController: UITableViewController {
    
    // MARK: - Properties
    
    private var shareBarButton: UIBarButtonItem!
    private var titleIsEmpty = true
    private var contentIsEmpty = true
    
    private lazy var customToolBarView = CustomToolBarView(
        frame: CGRect(x: 0, y: 0,
                      width: view.frame.width,
                      height: 60))
    
    override var inputAccessoryView: UIView? {
        return customToolBarView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
    }
    
    // MARK: - Actions
    
    func titleTextDidChange(textView: UITextView) {
        titleIsEmpty = textView.text.isEmpty
        tableViewUpdate()
    }
    
    func contentTextDidChange(textView: UITextView) {
        contentIsEmpty = textView.text.isEmpty
        tableViewUpdate()
    }
    
    
    // MARK: - Helpers
    
    func configureNavi() {
        title = "글쓰기"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 16)!]
        
        let backBarButton = UIBarButtonItem(
            image: UIImage(named: "naviBar_BackBtnIcon"),
            style: .plain,
            target: nil,
            action: nil)
        backBarButton.tintColor = .vegeTextBlackColor
        navigationItem.leftBarButtonItem = backBarButton
        
        shareBarButton = UIBarButtonItem(
            title: "공유",
            style: .plain,
            target: nil,
            action: nil)
        shareBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.buttonDisabledTextColor
        ], for: .disabled)
        shareBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.buttonEnabledTextcolor
        ], for: .normal)
        navigationItem.rightBarButtonItem = shareBarButton
        shareBarButton.isEnabled = false
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func configureUI() {
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        
        tableView.register(
            WriteTitleTableCell.self,
            forCellReuseIdentifier: WriteTitleTableCell.identifer)
        tableView.register(
            WriteMapTableCell.self,
            forCellReuseIdentifier: WriteMapTableCell.identifer)
        tableView.register(
            WriteImageTableCell.self,
            forCellReuseIdentifier: WriteImageTableCell.identifer)
        tableView.register(
            WriteContentTableCell.self,
            forCellReuseIdentifier: WriteContentTableCell.identifer)
    }
    
    func tableViewUpdate() {
        // https://www.swiftdevcenter.com/the-dynamic-height-of-uitextview-inside-uitableviewcell-swift/
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        if titleIsEmpty || contentIsEmpty {
            shareBarButton.isEnabled = false
        } else {
            shareBarButton.isEnabled = true
        }
    }
}


// MARK: UITableView DataSource & Delegate

extension FeedWriteController {
    enum WriteSection: Int, CaseIterable {
        case title
        case map
        case image
        case content
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return WriteSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch WriteSection(rawValue: indexPath.section)! {
        case .title:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WriteTitleTableCell.identifer,
                for: indexPath) as! WriteTitleTableCell
            cell.titleTextDidChange = titleTextDidChange(textView:)
            return cell
        case .map:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WriteMapTableCell.identifer,
                for: indexPath) as! WriteMapTableCell
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WriteImageTableCell.identifer,
                for: indexPath) as! WriteImageTableCell
            return cell
        case .content:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WriteContentTableCell.identifer,
                for: indexPath) as! WriteContentTableCell
            cell.contentTextDidChange = contentTextDidChange(textView:)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if WriteSection(rawValue: indexPath.section)! == .image {
            return UIScreen.main.bounds.width
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
