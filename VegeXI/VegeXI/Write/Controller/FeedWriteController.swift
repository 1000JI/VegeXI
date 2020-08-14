//
//  FeedWriteControllerr.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/12.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import Alamofire

class FeedWriteController: UITableViewController {
    
    // MARK: - Properties
    
    private var shareBarButton: UIBarButtonItem!
    private var feedTitle: String = ""
    private var titleIsEmpty = true
    private var feedContent: String = ""
    private var contentIsEmpty = true
    
    private var location: LocationModel? {
        didSet { tableView.reloadData() }
    }
    
    private var imageArray = [UIImage]() {
        didSet { print(imageArray); tableView.reloadData() }
    }
    private let imagePicker = ImagePickerController().then {
        $0.settings.selection.max = 10
        $0.settings.theme.selectionStyle = .numbered
        $0.settings.fetch.assets.supportedMediaTypes = [.image]
        $0.settings.selection.unselectOnReachingMax = true
    }
    
    private lazy var customToolBarView = CustomToolBarView(
        frame: CGRect(x: 0, y: 0,
                      width: view.frame.width,
                      height: 60)).then {
                        $0.tappedCameraButton = tappedCameraButton
                        $0.tappedLocationButton = tappedLocationButton
    }
    
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
    
    func tappedLocationDelete() {
        location = nil
    }
    
    func titleTextDidChange(textView: UITextView) {
        feedTitle = textView.text
        titleIsEmpty = feedTitle.isEmpty
        tableViewUpdate(isContentMode: false)
    }
    
    func contentTextDidChange(textView: UITextView) {
        feedContent = textView.text
        contentIsEmpty = feedContent.isEmpty
        tableViewUpdate(isContentMode: true)
    }
    
    func tappedCameraButton() {
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        option.resizeMode = .none
        
        self.presentImagePicker(imagePicker, select: { (asset) in
//            print("Selected: \(asset)")
        }, deselect: { (asset) in
//            print("Deselected: \(asset)")
        }, cancel: { (assets) in
//            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
//            debugPrint("Finished with selections: \(assets)")
            self.imageArray.removeAll()
            self.showLoader(true)
            assets.forEach {
                PHImageManager.default().requestImage(
                    for: $0,
                    targetSize: PHImageManagerMaximumSize,
                    contentMode: .aspectFill,
                    options: option) { (image, error) in
                        self.showLoader(false)
                        guard let image = image else { return }
                        self.imageArray.append(image)
                }
            }
        }, completion: {
            
        })
    }
    
    func tappedLocationButton() {
        let controller = SearchLocationController()
        controller.delegate = self
        let naviController = UINavigationController(rootViewController: controller)
        naviController.modalPresentationStyle = .fullScreen
        present(naviController, animated: true)
    }
    
    
    // MARK: - Seletors
    
    @objc
    func tappedShareButton() {
//        FeedService.shared.uploadFeed(
//            title: feedTitle,
//            content: feedContent,
//            imageArray: imageArray,
//            location: location) { (error, ref) in
//                if let error = error {
//                    print("DEBUG: \(error.localizedDescription)")
//                    return
//                }
//                print("FEED UPLOAD SUCCESS")
//                self.dismiss(animated: true, completion: nil)
//        }
        let controller = SharePostViewController()
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }
    
    @objc
    func tappedCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func configureNavi() {
        title = "글쓰기"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 16)!]
        
        let cancelBarButton = UIBarButtonItem(
            image: UIImage(named: "write_Cancel_Icon"),
            style: .plain,
            target: self,
            action: #selector(tappedCloseButton))
        cancelBarButton.tintColor = .vegeTextBlackColor
        navigationItem.leftBarButtonItem = cancelBarButton
        
        shareBarButton = UIBarButtonItem(
            title: "공유",
            style: .plain,
            target: self,
            action: #selector(tappedShareButton))
        shareBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.buttonDisabledTextColor
        ], for: .disabled)
        shareBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.buttonEnabledTextcolor
        ], for: .normal)
        navigationItem.rightBarButtonItem = shareBarButton
        
        if titleIsEmpty || contentIsEmpty {
            shareBarButton.isEnabled = false
        } else {
            shareBarButton.isEnabled = true
        }
        
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
    
    func tableViewUpdate(isContentMode: Bool) {
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
        
        
        if isContentMode {
            let indexPath = IndexPath(
                item: 0,
                section: WriteSection.content.rawValue)
            tableView.scrollToRow(
                at: indexPath,
                at: .bottom,
                animated: false)
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
        switch WriteSection(rawValue: section)! {
        case .title: fallthrough
        case .content: return 1
        case .map:
            return location != nil ? 1 : 0
        case .image:
            return imageArray.count > 0 ? 1 : 0
        }
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
            cell.location = location
            cell.tappedDeleteEvent = tappedLocationDelete
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WriteImageTableCell.identifer,
                for: indexPath) as! WriteImageTableCell
            cell.imageArray = imageArray
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

// MARK: - SearchLocationControllerDelegate

extension FeedWriteController: SearchLocationControllerDelegate {
    func seletedLocation(location: LocationModel) {
        self.location = location
    }
}
