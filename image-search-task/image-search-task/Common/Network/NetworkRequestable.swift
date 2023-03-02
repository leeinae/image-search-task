//
//  NetworkRequestable.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/01.
//

import Alamofire
import Foundation

protocol NetworkRequestable {
    typealias Parameters = [String: Any]
    
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }

    func endpoint() throws -> URL
}

extension NetworkRequestable {
    var baseURL: String {
        Environment.apiHost
    }

    var path: String {
        ""
    }

    var method: HTTPMethod {
        .get
    }

    var parameters: Parameters? {
        nil
    }

    var headers: HTTPHeaders {
        [
            "Authorization": "KakaoAK \(Environment.kakaoAPIKey)"
        ]
    }
}

extension NetworkRequestable {
    func endpoint() throws -> URL {
        guard let endpoint = URL(string: baseURL + path)
        else { throw NetworkError.wrongEndpoint }

        return endpoint
    }
}
