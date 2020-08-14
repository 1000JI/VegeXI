//
//  MyPageCategoryView.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/13/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class MyPageCategoryView: UIView {
    
    // MARK: - Properties
    private let firstSection = UIView()
    private let firstSectionLabel = UILabel().then {
        $0.text = MyPageStrings.myPost.generateString()
        $0.font = UIFont.spoqaHanSansBold(ofSize: 15)
        $0.textColor = .vegeTextBlackColor
    }
    private let secondSection = UIView()
    private let secondSectionLabel = UILabel().then {
        $0.text = MyPageStrings.myBookmark.generateString()
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 15)
        $0.textColor = .vegeCategoryTextColor
    }
    private let separator = UIView().then {
        $0.backgroundColor = .vegeLightGrayButtonColor
    }
    private let sectionIndicator = UIView().then {
        $0.backgroundColor = .vegeTextBlackColor
    }
    private var selectedSectionNumber = 0
    
    private var firstSectionTapGesture: UITapGestureRecognizer?
    private var secondSectionTapGesture: UITapGestureRecognizer?
    private var controlSections: (Int) -> Void = { _ in return }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        firstSectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestures(_:)))
        secondSectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestures(_:)))
        
        guard let firstSectionTapGesture = firstSectionTapGesture, let secondSectionTapGesture = secondSectionTapGesture else { return }
        firstSection.addGestureRecognizer(firstSectionTapGesture)
        firstSection.isUserInteractionEnabled = true
        secondSection.addGestureRecognizer(secondSectionTapGesture)
        secondSection.isUserInteractionEnabled = true
    }
    
    private func setConstraints() {
        let viewSize = UIScreen.main.bounds.size
        [firstSection, secondSection, separator, sectionIndicator].forEach {
            self.addSubview($0)
        }
        firstSection.addSubview(firstSectionLabel)
        secondSection.addSubview(secondSectionLabel)
        
        firstSection.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(viewSize.width / 2)
            $0.height.equalToSuperview()
        }
        secondSection.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(firstSection.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.height.equalToSuperview()
        }
        firstSectionLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        secondSectionLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        separator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        sectionIndicator.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.trailing.equalTo(firstSection)
            $0.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: - Helpers
    private func handleSectionSelected(sectionNumber: Int) {
        UIView.animate(withDuration: 0.15) {
            switch sectionNumber {
            case 0:
                self.firstSectionLabel.font = UIFont.spoqaHanSansBold(ofSize: 15)
                self.firstSectionLabel.textColor = .vegeTextBlackColor
                self.secondSectionLabel.font = UIFont.spoqaHanSansRegular(ofSize: 15)
                self.secondSectionLabel.textColor = .vegeCategoryTextColor
            case 1:
                self.firstSectionLabel.font = UIFont.spoqaHanSansRegular(ofSize: 15)
                self.firstSectionLabel.textColor = .vegeCategoryTextColor
                self.secondSectionLabel.font = UIFont.spoqaHanSansBold(ofSize: 15)
                self.secondSectionLabel.textColor = .vegeTextBlackColor
            default:
                break
            }
            self.layoutIfNeeded()
        }
        animateIndicator(sectionNumber: sectionNumber)
    }
    
    private func animateIndicator(sectionNumber: Int) {
        UIView.animate(withDuration: 0.15) {
            switch sectionNumber {
            case 0:
                self.sectionIndicator.snp.removeConstraints()
                self.sectionIndicator.snp.makeConstraints {
                    $0.height.equalTo(2)
                    $0.leading.trailing.equalTo(self.firstSection)
                    $0.bottom.equalToSuperview()
                }
            case 1:
                self.sectionIndicator.snp.removeConstraints()
                self.sectionIndicator.snp.makeConstraints {
                    $0.height.equalTo(2)
                    $0.leading.trailing.equalTo(self.secondSection)
                    $0.bottom.equalToSuperview()
                }
            default:
                break
            }
            self.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTapGestures(_ sender: UITapGestureRecognizer) {
        switch sender {
        case firstSectionTapGesture:
            selectedSectionNumber = 0
            handleSectionSelected(sectionNumber: selectedSectionNumber)
            controlSections(selectedSectionNumber)
        case secondSectionTapGesture:
            selectedSectionNumber = 1
            handleSectionSelected(sectionNumber: selectedSectionNumber)
            controlSections(selectedSectionNumber)
        default:
            break
        }
    }
    
    
    // MARK: - Helpers
    func prepareForActions(action: @escaping (Int) -> Void) {
        controlSections = action
    }
    
}
