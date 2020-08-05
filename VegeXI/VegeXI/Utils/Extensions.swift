//
//  Extensions.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/05.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoader(_ show: Bool, withText text: String? = "Loading") {
        view.endEditing(true)
        
        UIViewController.hud.textLabel.text = text
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
}
