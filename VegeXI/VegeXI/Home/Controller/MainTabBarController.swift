//
//  MainTabBarController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/07.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var userUid: String? {
        didSet { fetchUser() }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMiddleButton()
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = userUid else { return }
        
        showLoader(true)
        UserService.shared.fetchUser(uid: uid) { user in
            self.showLoader(false)
            
            UserService.shared.user = user
            print(#function, UserService.shared.user ?? "findUser")
        }
    }
    
    
    // MARK: - Helpers
    
    func configureTabBar() {
        let homeViewController = HomeViewController()
        let naviHome = UINavigationController(rootViewController: homeViewController)
        naviHome.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "tabbar_Home_Default"),
            selectedImage: UIImage(named: "tabbar_Home_Checked"))
        
        let writeViewController = WriteEmptyController()
        writeViewController.returnMethod = clickedWriteTabbar
        let naviWrite = UINavigationController(rootViewController: writeViewController)
        naviWrite.tabBarItem = UITabBarItem(
            title: "글쓰기",
            image: nil,
            selectedImage: nil)
        
        let myPageViewController = UIViewController()
        let naviMyPage = UINavigationController(rootViewController: myPageViewController)
        naviMyPage.tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: UIImage(named: "tabbar_MyPage_Default"),
            selectedImage: UIImage(named: "tabbar_MyPage_Checked"))
        
        viewControllers = [naviHome, naviWrite, naviMyPage]
        
        
        // Appearance
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = .tabbarGreenSelectColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.tabbarGreenSelectColor,
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 9)!
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .vegeTextBlackColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.vegeTextBlackColor,
            NSAttributedString.Key.font: UIFont.spoqaHanSansRegular(ofSize: 9)!,
        ]
        
        tabBar.isTranslucent = false
        tabBar.standardAppearance = appearance
    }
    
    func setupMiddleButton() {
        let buttonSize: CGFloat = 52
        let registerButton = UIButton(
            frame: CGRect(
                x: 0, y: 0,
                width: buttonSize, height: buttonSize))
        
        var menuButtonFrame = registerButton.frame
        menuButtonFrame.origin.y = tabBar.frame.minY - (buttonSize / 2 - 4)
        menuButtonFrame.origin.x = view.center.x - (buttonSize / 2)
        registerButton.frame = menuButtonFrame
        
        registerButton.backgroundColor = UIColor.systemGreen
        registerButton.layer.cornerRadius = menuButtonFrame.height / 2
        view.addSubview(registerButton)
        
        registerButton.setImage(UIImage(named: "tabbar_PlusButton"), for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
    }
    
    
    // MARK: - Actions
    
    @objc private func registerButtonAction(sender: UIButton?) {
        selectedIndex = 0
    }
    
    func clickedWriteTabbar() {
        registerButtonAction(sender: nil)
    }
}
