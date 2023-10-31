//
//  NaverLoginResponse.swift
//  NaverLoginSample
//
//  Created by Ethan Parker on 10/31/23.
//

import Foundation

struct NaverLoginResponse: Decodable {
    var response: NaverResponse
    
    struct NaverResponse: Decodable {
        let id: String // 동일인 식별 정보, 네이버 아이디마다 고유하게 발급되는 유니크한 일련번호 값
        let nickname: String
        let name: String
        let email: String
        let gender: String // - F: 여성 - M: 남성 - U: 확인불가
        let age: String // 사용자 연령대
        let birthday: String // 사용자 생일(MM-DD 형식)
        let birthyear: Int
        let mobile: String
        let profileImage: URL?
        
        enum CodingKeys: String, CodingKey {
            case id
            case nickname
            case name
            case email
            case gender
            case age
            case birthday
            case birthyear
            case mobile
            case profileImage = "profile_image"
        }
    }
}
