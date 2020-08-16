//
//  SettingViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: SettingViewStrings.barTitle.generateString())
    private let settingTableView = UITableView()
    
    private var notificationSwitchCell: SettingTableViewCell?
    private var notificationSetting: Bool { // 유저가 설정한 Notification 값
        if let status = notificationSwitchCell?.switchStatus {
            return status
        }
        fatalError()
    }
    
    
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
        setStoredPropertyAttributes()
        setConstraints()
    }
    
    private func setStoredPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleTopBarLeftBarButton(_:)), for: .touchUpInside)
        
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.isScrollEnabled = false
        settingTableView.separatorStyle = .none
    }
    
    private func setConstraints() {
        [topBarView, settingTableView].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTopBarLeftBarButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helpers
    private func configureCellType(cellType: String) -> SettingViewCellType {
        switch cellType {
        case "defualt":
            return .defualt
        case "subtitle":
            return .subtitlte
        case "info":
            return .info
        case "pager":
            return .paging
        case "switcher":
            return .switcher
        default:
            fatalError(cellType)
        }
    }
    
}


// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingCategories.instance.categoryInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { fatalError() }
        guard
            let title = SettingCategories.instance.categoryInfo[indexPath.row]["title"],
            let subtitle = SettingCategories.instance.categoryInfo[indexPath.row]["subtitle"],
            let info = SettingCategories.instance.categoryInfo[indexPath.row]["info"],
            let cellTypeInString = SettingCategories.instance.categoryInfo[indexPath.row]["type"]
            else { fatalError() }
        let cellType = configureCellType(cellType: cellTypeInString)
        
        let lastCellIndex = SettingCategories.instance.categoryInfo.count - 1
        let hideSeparator = indexPath.row == lastCellIndex ? true : false
        cell.configureCell(title: title, subtitle: subtitle, info: info, isOn: false, cellType: cellType, separatorIsHidden: hideSeparator)
        if indexPath.row == 0 {
            notificationSwitchCell = cell
        }
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellTypeInString = SettingCategories.instance.categoryInfo[indexPath.row]["type"] else { fatalError() }
        let cellType = configureCellType(cellType: cellTypeInString)
        switch cellType {
        case .subtitlte:
            return 90
        default:
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = SettingCategories.instance.categoryInfo[indexPath.row]["title"] else { return }
        switch title {
        case "푸시알림 설정":
            print(notificationSetting)
        case "비밀번호 변경":
            let nextVC = ForgotPasswordViewController()
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        case "문의/버그신고":
            let nextVC = BugReportViewController()
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        case "서비스 이용 약관":
            let nextVC = ExplanationViewController()
            nextVC.hidesBottomBarWhenPushed = true
            nextVC.configureViewController(title: "서비스 이용 약관", content: SettingCategories.instance.agreement)
            navigationController?.pushViewController(nextVC, animated: true)
        case "개인정보 처리방침":
            let nextVC = ExplanationViewController()
            nextVC.hidesBottomBarWhenPushed = true
            nextVC.configureViewController(title: "개인정보 처리방침", content: SettingCategories.instance.privacyPolicy)
            navigationController?.pushViewController(nextVC, animated: true)
        case "로그아웃":
            let alert = UIAlertController(title: "정말 로그아웃하시겠습니까?", message: nil, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "로그아웃", style: .destructive, handler: nil)
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        default:
            return
        }
    }
    
}
