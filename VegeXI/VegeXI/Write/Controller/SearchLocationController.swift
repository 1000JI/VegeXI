//
//  SearchLocationController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/13.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchLocationControllerDelegate: class {
    func seletedLocation(location: LocationModel)
}

class SearchLocationController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: SearchLocationControllerDelegate?
    
    private let sidePadding: CGFloat = 20
    
    private var locationManager: CLLocationManager!
    private var latitude: Double?
    private var longitude: Double?
    private var locations = [LocationModel]() {
        didSet { resultTableView.reloadData() }
    }

    private lazy var searchBarView = LocationSearchBar().then {
        $0.searchKeywordEvent = searchKeywordEvent(keyword:)
    }
    private lazy var resultTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .interactive
        $0.dataSource = self
        $0.delegate = self
        $0.tableFooterView = UIView()
        $0.register(ResultTableCell.self,
                    forCellReuseIdentifier: ResultTableCell.identifier)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let locationManager = locationManager else { return }
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Actions
    
    func searchKeywordEvent(keyword: String) {
        view.endEditing(true)
        MapService.shared.searchLocations(keyword: keyword) { locations in
            self.locations = locations
        }
    }
    
    // MARK: - Selectors
    
    @objc
    func tappedCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        [searchBarView, resultTableView].forEach {
            view.addSubview($0)
        }
        
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(sidePadding)
            $0.trailing.equalToSuperview().offset(-sidePadding)
            $0.height.equalTo(44)
        }
        
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(sidePadding)
            $0.trailing.equalToSuperview().offset(-sidePadding)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureNavi() {
        title = "장소 첨부"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.spoqaHanSansBold(ofSize: 16)!]
        
        let cancelBarButton = UIBarButtonItem(
            image: UIImage(named: "write_Cancel_Icon"),
            style: .plain,
            target: self,
            action: #selector(tappedCloseButton))
        cancelBarButton.tintColor = .vegeTextBlackColor
        navigationItem.leftBarButtonItem = cancelBarButton
        
        navigationController?.removeUnderLineWhiteNaviBar()
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}


// MARK: - CLLocationManagerDelegate

extension SearchLocationController: CLLocationManagerDelegate {
    // https://tom7930.tistory.com/28
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate {
            self.latitude = Double(coor.latitude)
            self.longitude = Double(coor.longitude)
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchLocationController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ResultTableCell.identifier,
            for: indexPath) as! ResultTableCell
        cell.location = locations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.item]
        delegate?.seletedLocation(location: location)
        self.dismiss(animated: true, completion: nil)
    }
}
