//
//  FeedRegisterController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/07.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class FeedRegisterController: UIViewController {
    
    // MARK: - Properties
    
    private var imageArray = [UIImage]()
    
    let imagePicker = ImagePickerController()
    
    lazy var imagePickerButton = UIButton(type: .system).then {
        $0.setTitle("imagePicker", for: .normal)
        $0.addTarget(self,
                     action: #selector(handelImagePicker),
                     for: .touchUpInside)
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray
    }
    
    let titleTextField = UITextField().then {
        $0.placeholder = "title"
    }
    
    let contentTextView = UITextView().then {
        $0.backgroundColor = .systemGroupedBackground
    }
    
    lazy var registerButton = UIButton(type: .system).then {
        $0.setTitle("register", for: .normal)
        $0.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(imagePickerButton)
        imagePickerButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(80)
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imagePickerButton.snp.bottom).offset(20)
            $0.width.height.equalTo(120)
        }
        
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.width.equalTo(120)
        }
        
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.width.height.equalTo(120)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentTextView.snp.bottom).offset(20)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleRegister() {
//        guard let title = titleTextField.text else { return }
//        guard let content = contentTextView.text else { return }
//
//        FeedService.shared.uploadFeed(title: title, content: content, imageArray: imageArray) { (error, ref) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//                return
//            }
//            print("Feed Upload Success!!!")
//        }
    }
    
    @objc func handelImagePicker() {
        imagePicker.settings.selection.max = 10
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true
        
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.isNetworkAccessAllowed = false
        option.resizeMode = .exact
        
//        let start = Date()
        self.presentImagePicker(imagePicker, select: { (asset) in
//            print("Selected: \(asset)")
        }, deselect: { (asset) in
//            print("Deselected: \(asset)")
        }, cancel: { (assets) in
//            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
//            debugPrint("Finished with selections: \(assets)")
            // https://zeddios.tistory.com/620
            // https://stackoverflow.com/questions/57658263/ios13-get-original-image-using-phimagemanager
            assets.forEach {
                PHImageManager.default().requestImage(
                    for: $0,
                    targetSize: PHImageManagerMaximumSize,
                    contentMode: .aspectFit,
                    options: option) { (image, nil) in
                        guard let image = image else { return }
                        self.imageView.image = image
                        self.imageArray.append(image)
                }
            }
        }, completion: {
//            let finish = Date()
//            print(finish.timeIntervalSince(start))
        })
    }
    
    // MARK: - Helpers
    
}
