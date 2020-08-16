//
//  EditProfileViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditProfileViewController: UIViewController {

    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: EditProfileStrings.barTitle.generateString())
    private let editingView = EditProfileEditingView()
    private let typeSelectionView = EditProfileSelectTypeView()
    private let bottomBarView = FilterViewBottomBar(title: EditProfileStrings.confirm.generateString())
    
    private lazy var typeTableView = typeSelectionView.vegeTypeTableView
    private var selectedCell: IndexPath = IndexPath() // 유저가 선택한 타입의 정보가 저장
    private var vegeType: VegeType {
        configureVegeType(selectedCell: selectedCell)
    }
    
    private let imagePicker = UIImagePickerController()
    
    var user: User? {
        didSet { configureViewData() }
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
        editingView.profileEditButton.addTarget(self, action: #selector(handleProfileEditButton(_:)), for: .touchUpInside)
        editingView.nicknameTextField.clearButton.addTarget(self, action: #selector(handleTextFieldClearButton(_:)), for: .touchUpInside)
        bottomBarView.configureBottomBar {
            self.handleBottomBarConfirmButton()
        }
        
        editingView.nicknameTextField.textField.delegate = self
        typeTableView.delegate = self
        imagePicker.delegate = self
    }
    
    private func setConstraints() {
        [topBarView, editingView, typeSelectionView, bottomBarView].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        editingView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        typeSelectionView.snp.makeConstraints {
            $0.top.equalTo(editingView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomBarView.snp.top).offset(-64)
        }
        bottomBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(75)
        }
    }
    
    func configureViewData() {
        guard let user = user else { return }
        editingView.user = user
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTopBarLeftBarButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func handleProfileEditButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        
        let cameraAction = UIAlertAction(title: EditProfileStrings.camera.generateString(), style: .default) { ACTION in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            self.imagePicker.sourceType = .camera
            self.imagePicker.mediaTypes = [kUTTypeImage] as [String]
            self.present(self.imagePicker, animated: true)
        }
        let albumAction = UIAlertAction(title: EditProfileStrings.album.generateString(), style: .default) { ACTION in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: EditProfileStrings.cancel.generateString(), style: .cancel, handler: nil)
        [cameraAction, albumAction, cancelAction].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
    
    @objc
    private func handleTextFieldClearButton(_ sender: UIButton) {
        editingView.nicknameTextField.textField.text = ""
    }
    
    private func handleBottomBarConfirmButton() {
        print(#function)
    }
    
    
    // MARK: - Helpers
    private func configureVegeType(selectedCell: IndexPath) -> VegeType {
        switch selectedCell.row {
        case 0:
            return .vegan
        case 1:
            return .ovo
        case 2:
            return .lacto
        case 3:
            return .lacto_ovo
        case 4:
            return .pesco
        case 5:
            return .nothing
        default:
            return .nothing
        }
    }

}


// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            editingView.nicknameTextField.clearButton.isHidden = true
        } else {
            editingView.nicknameTextField.clearButton.isHidden = false
        }
    }
}


// MARK: - UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EditProfileTypeTableViewCell else { return }
        typeSelectionView.tableViewCells.forEach {
            $0.isClicked = false
        }
        cell.isClicked = true
        selectedCell = indexPath
        print(vegeType)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EditProfileTypeTableViewCell else { return }
        cell.isClicked = false
    }
}


// MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! NSString
        if UTTypeEqual(mediaType, kUTTypeImage) {
            let originalImage = info[.originalImage] as! UIImage
            let editedImage = info[.editedImage] as? UIImage

            let selectedImage = editedImage ?? originalImage
            editingView.profileImageView.image = selectedImage
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}
