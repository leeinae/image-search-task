//
//  Environment.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/02.
//

import Foundation

struct Environment {
    static var apiHost = Bundle.main.infoDictionary?["API_HOST"] as? String ?? ""
    static var kakaoAPIKey = Bundle.main.infoDictionary?["KAKAO_REST_API_KEY"] as? String ?? ""
}
