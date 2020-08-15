//
//  BugReportViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import MessageUI

class BugReportViewController: UIViewController {
    
    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: "문의/버그신고")
    private let textView = UITextView().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.vegeLightGrayBorderColor.cgColor
        $0.layer.cornerRadius = 5
    }
    private let sendButton = SignButton(title: "보내기")
    private let composeVC = MFMailComposeViewController()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setEmailConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleLeftBarButton(_:)), for: .touchUpInside)
        textView.delegate = self
        textView.becomeFirstResponder()
        sendButton.addTarget(self, action: #selector(handleSendButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [topBarView, textView, sendButton].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(250)
        }
        sendButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(textView)
            $0.height.equalTo(48)
        }
    }
    
    
    // MARK: - Helpers
    private func setEmailConfiguration() {
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(
                title: nil,
                message: """
이 디바이스에서는
지원하지 않는 기능입니다.
""",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "확인",
                style: .default,
                handler: { _ in self.navigationController?.popViewController(animated: true) }
            ))
            print("Mail services are not available")
            self.present(alert, animated: true)
        }
        return
    }
    
    private func sendEmail() {
        guard let text = textView.text else { return }
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["KasRoid@gmail.com", "chjh1992@gmail.com"])
        composeVC.setSubject("버그 리포팅")
        composeVC.setMessageBody(text, isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleLeftBarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func handleSendButton(_ sender: UIButton) {
        sendEmail()
        let alert = UIAlertController(title: nil, message: "성공적으로 발송되었습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "확인",
            style: .default,
            handler: { _ in self.navigationController?.popViewController(animated: true) }
        ))
        self.present(alert, animated: true)
    }
    
}


// MARK: - UITextViewDelegate
extension BugReportViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        sendButton.isActive = textView.text != "" ? true : false
    }
    
}


extension BugReportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
