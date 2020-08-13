//
//  MapService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/13.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation
import Alamofire

struct LocationModel {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let placeUrl: URL?
    let longitude: Double
    let latitude: Double
    
    init(dictionary: [String: Any]) {
        self.placeName = dictionary["place_name"] as? String ?? "느린채식"
        self.addressName = dictionary["address_name"] as? String ?? "느린채식"
        self.roadAddressName = dictionary["road_address_name"] as? String ?? "느린채식"
        
        let urlString = dictionary["place_url"] as? String ?? ""
        self.placeUrl = URL(string: urlString)
        
        let xValue = dictionary["x"] as? String ?? "0"
        self.longitude = Double(xValue)!
        
        let yValue = dictionary["y"] as? String ?? "0"
        self.latitude = Double(yValue)!
    }
}

/*
 ["y": 37.5717289373613, "category_group_code": FD6, "address_name": 서울 종로구 창신동 697-3, "place_name": 일루오리 창신동점, "distance": , "x": 127.009875392761, "category_group_name": 음식점, "place_url": http://place.map.kakao.com/21326591, "category_name": 음식점 > 한식 > 육류,고기 > 오리, "phone": 02-3676-5292, "road_address_name": 서울 종로구 낙산성곽길 2, "id": 21326591]
 */

struct MapService {
    static let shared = MapService()
    private init() { }
    
    func searchLocations(keyword: String, completion: @escaping([LocationModel]) -> Void) {
        var locations = [LocationModel]()
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(KAKAO_RESTFUL_KEY)"]
        let parameters: [String: Any] = [
            "query": keyword.utf8]
        
        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get, parameters: parameters, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                guard let values = value as? [String:Any],
                    let dictionary = values["documents"] as? [[String:Any]] else { return }
                
                dictionary.forEach {
                    let location = LocationModel(dictionary: $0)
                    locations.append(location)
                }
                
                completion(locations)
            case .failure(let error):
                print(error)
            }
        }
    }
}
