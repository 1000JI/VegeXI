//
//  NotificationViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/11/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    // MARK: - Properties
    private let topBar = NotificationViewTopBar(title: GeneralStrings.notification.generateString())
    private let infoLabel = UILabel().then {
        $0.text = GeneralStrings.emptyNotification.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 16)
        $0.textColor = .vegeLightGraySearchHistoryClearButtonColor
    }
    private let notificationTableView = UITableView()
    
    private var data = MockData.notificationData
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        notificationTableView.backgroundColor = .white
        notificationTableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.identifier)
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
        notificationTableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        topBar.addGestureRecognizer(tapGesture)
    }
    
    private func setConstraints() {
        [topBar, infoLabel, notificationTableView].forEach {
            view.addSubview($0)
        }
        topBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        infoLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        notificationTableView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: - Selectors
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        print(#function)
    }
    
}


// MARK: - UITableViewDataSource
extension NotificationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notificationTableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as? NotificationTableViewCell else { fatalError() }
        guard let profile = data[indexPath.row]["profile"] else { fatalError() }
        guard let nickname = data[indexPath.row]["nickname"] else { fatalError() }
        guard let system = data[indexPath.row]["system"] else { fatalError() }
        guard let content = data[indexPath.row]["content"] else { fatalError() }
        guard let image = data[indexPath.row]["image"] else { fatalError() }
        guard let time = data[indexPath.row]["time"] else { fatalError() }
        var type: FeedType = .picAndTextType
        if image == "" {
            type = .textType
        }
        cell.configureCell(profile: profile, nickname: nickname, system: system, content: content, image: image, time: time, type: type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
}


// MARK: - UITableViewDelegate
extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (contextualAction, view, success) in
            self.data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
            success(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}
