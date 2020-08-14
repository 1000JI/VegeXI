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
    
    func isTabbarHidden(isHidden: Bool) {
        guard let mainTabbarController = tabBarController as? MainTabBarController else { return }
        mainTabbarController.registerButton.isHidden = isHidden
        tabBarController?.tabBar.isHidden = isHidden
    }
    
    func keyboardWillShowNotification(handler: @escaping((Notification) -> ())) {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { notification in
                handler(notification)
        }
    }
    
    func keyboardWillHideNotification(handler: @escaping((Notification) -> ())) {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { notification in
                handler(notification)
        }
    }
    
    func showMoreBasicButtnAlert(viewController: UIViewController,
                            reportHandler: ((UIAlertAction) -> Void)?,
                            linkCopyHandler: ((UIAlertAction) -> Void)?,
                            shareHandler: ((UIAlertAction) -> Void)?) {
        let moreAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(
            title: "신고",
            style: .destructive,
            handler: reportHandler)
        let linkCopyAction = UIAlertAction(
            title: "링크복사",
            style: .default,
            handler: linkCopyHandler)
        let shareAction = UIAlertAction(
            title: "공유하기",
            style: .default,
            handler: shareHandler)
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil)
        
        moreAlert.addAction(reportAction)
        moreAlert.addAction(linkCopyAction)
            moreAlert.addAction(shareAction)
        moreAlert.addAction(cancelAction)
        moreAlert.view.tintColor = .black
        
        viewController.present(moreAlert, animated: true)
    }
    
    func showMoreWriterButtnAlert(viewController: UIViewController,
                            editHandler: ((UIAlertAction) -> Void)?,
                            linkCopyHandler: ((UIAlertAction) -> Void)?,
                            shareHandler: ((UIAlertAction) -> Void)?,
                            deleteHandler: ((UIAlertAction) -> Void)?) {
        let moreAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(
            title: "수정",
            style: .destructive,
            handler: editHandler)
        let linkCopyAction = UIAlertAction(
            title: "링크복사",
            style: .default,
            handler: linkCopyHandler)
        let shareAction = UIAlertAction(
            title: "공유하기",
            style: .default,
            handler: shareHandler)
        let deleteAction = UIAlertAction(
            title: "삭제",
            style: .default,
            handler: deleteHandler)
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil)
        
        moreAlert.addAction(editAction)
        moreAlert.addAction(linkCopyAction)
        moreAlert.addAction(shareAction)
        moreAlert.addAction(deleteAction)
        moreAlert.addAction(cancelAction)
        moreAlert.view.tintColor = .black
        
        viewController.present(moreAlert, animated: true)
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
    static let vegeLightGrayForInfoView = UIColor(rgb: 0xF2F2F2)
    static let vegeLightGrayCellBorderColor = UIColor(rgb: 0xCCCCCC)
    static let vegeGraySearchBarPlaceHolderColor = UIColor(rgb: 0x9F9F9F)
    static let vegeTextBlackColor = UIColor(rgb: 0x303033)
    static let vegeWarningRedColor = UIColor(rgb: 0xD51D1D)
    static let vegeCategoryTextColor = UIColor(rgb: 0x707070)
    static let tabbarGreenSelectColor = UIColor(rgb: 0x156941)
    static let vegeSelectedGreen = UIColor(rgb: 0x0AB682)
    static let vegeCommentDateColor = UIColor(rgb: 0xB7B7B7)
    static let vegeLightGrayVegeInfoThinBar = UIColor(rgb: 0xE5E5E5)
    static let buttonDisabledTextColor = UIColor(rgb: 0xD8D8D8)
    static let buttonEnabledTextcolor = UIColor(rgb: 0x0AB682)
    static let textViewPlaceholderTextColor = UIColor(rgb: 0xA5A5A5)
    static let postGray = UIColor(rgb: 0xA5A5A5)
    
}

extension UIFont {
    static func spoqaHanSansBold(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "SpoqaHanSans-Bold", size: ofSize)
    }
    
    static func spoqaHanSansRegular(ofSize: CGFloat) -> UIFont? {
        return UIFont(name: "SpoqaHanSans-Regular", size: ofSize)
    }
}


extension UIImage {
    static let basicHumanImage = UIImage(named: "cell_Human")?.withRenderingMode(.alwaysOriginal)
}
