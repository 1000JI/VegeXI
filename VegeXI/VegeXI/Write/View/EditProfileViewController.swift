//
//  EditProfileViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: EditProfileStrings.barTitle.generateString())
    private let editingView = EditProfileEditingView()
    private let typeSelectionView = EditProfileSelectTypeView()
    private let bottomBarView = FilterViewBottomBar(title: EditProfileStrings.confirm.generateString())
    
    private lazy var typeTableView = typeSelectionView.vegeTypeTableView
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
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
    
    
    // MARK: - Selectors
    @objc
    private func handleTopBarLeftBarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func handleProfileEditButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: EditProfileStrings.camera.generateString(), style: .default, handler: nil)
        let albumAction = UIAlertAction(title: EditProfileStrings.album.generateString(), style: .default, handler: nil)
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
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EditProfileTypeTableViewCell else { return }
        cell.isClicked = false
    }
}
