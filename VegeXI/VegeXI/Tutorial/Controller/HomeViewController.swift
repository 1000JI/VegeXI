//
//  HomeViewController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/05.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var userUid: String?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPurple
        print(#function, UserService.shared.user)
        
        fetchUser()
    }
    
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = userUid else { return }
        
        showLoader(true)
        UserService.shared.fetchUser(uid: uid) { user in
            self.showLoader(false)
            
            UserService.shared.user = user
            print(#function, UserService.shared.user)
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
    }
    
}
