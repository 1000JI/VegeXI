//
//  UserService.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/05.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import Foundation

enum MyPostFilter: String {
    case entirePosts = "전체"
    case publicPosts = "공개"
    case privatePosts = "비공개"
}

enum VegeType: String {
    case vegan
    case ovo
    case lacto
    case lacto_ovo
    case pesco
    case nothing
}

enum LoginType: String {
    case kakao
    case naver
    case google
    case apple
    case basic
}

enum CategoryType: String {
    case diet = "식단"
    case location = "장소"
    case product = "제품"
    case content = "컨텐츠"
}

enum PostCategory: String {
    // 식단
    case koreanFood = "한식"
    case snackBar = "분식"
    case japaneseFood = "일식"
    case chineseFood = "중식"
    case westernFood = "양식"
    case eastAsianFood = "동남아"
    case indianFood = "인도, 중동"
    case breadAndCoffee = "빵, 커피"
    case alcohol = "술"
    // 장소
    case restuarant = "식당"
    case bakeryAndCafe = "베이커리, 카페"
    case houseHoldGoodsStore = "생활용품점"
    case Exhibition = "전시회, 박랍회"
    // 제품
    case cosmetics = "화장품"
    case houseHoldGoods = "생활용품"
    case fashion = "패션"
    // 컨텐츠
    case influencer = "인플루언서"
    case book = "책"
    case movie = "영화"
    case documentary = "다큐멘터리"
    
    case noInfo = ""
}

struct User {
    let email: String
    let nickname: String
    let profileImageUrl: URL
    let uid: String
    let loginType: LoginType
    let vegeType: VegeType
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
        
        let imageString = dictionary["profileImageUrl"] as? String ?? ""
        self.profileImageUrl = URL(string: imageString)!
        self.uid = dictionary["uid"] as? String ?? ""
        
        let typeString = dictionary["type"] as? String ?? "basic"
        self.loginType = LoginType(rawValue: typeString)!
        
        let vegeTypeString = dictionary["vegeType"] as? String ?? "nothing"
        self.vegeType = VegeType(rawValue: vegeTypeString)!
    }
    
    var profileVegeExplainText: String {
        switch self.vegeType {
        case .vegan: return "비건 지향"
        case .ovo: return "오보 지향"
        case .lacto: return "락토 지향"
        case .lacto_ovo: return "락토 오보 지향"
        case .pesco: return "페스코 지향"
        case .nothing:
            let presentUid = UserService.shared.user?.uid
            return self.uid == presentUid! ?
                "지향하는 채식타입을 설정해보세요" : "지향없음"
        }
    }
}

final class UserService {
    static let shared = UserService()
    private init() { }
    
    var user: User?
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(User(dictionary: dictionary))
        }
    }
}
