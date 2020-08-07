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
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static let vegeGreenButtonColor = UIColor(rgb: 0x71A08A)
    static let vegeLightGrayBorderColor = UIColor(rgb: 0xD8D8D8)
    static let vegeLightGrayButtonColor = UIColor(rgb: 0xD7D6D5)
    static let vegeLightGraySearchBarColor = UIColor(rgb: 0xF0F0F0)
    static let vegeLightGraySearchHistoryClearButtonColor = UIColor(rgb: 0x707070)
    static let vegeGraySearchBarPlaceHolderColor = UIColor(rgb: 0x9F9F9F)
    static let vegeTextBlackColor = UIColor(rgb: 0x303033)
    static let vegeWarningRedColor = UIColor(rgb: 0xD51D1D)
    static let vegeCategoryTextColor = UIColor(rgb: 0x707070)
    static let tabbarGreenSelectColor = UIColor(rgb: 0x156941)
    static let vegeSelectedGreend = UIColor(rgb: 0x0AB682)
}

extension UIFont {
    static func spoqaHanSansBold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "SpoqaHanSans-Bold", size: ofSize)
    }
    
    static func spoqaHanSansRegular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "SpoqaHanSans-Regular", size: ofSize)
    }
}


