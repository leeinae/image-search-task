//
//  NetworkError.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/04.
//

import Alamofire

enum NetworkError: Error {
    case wrongEndpoint
    case wrongRequest
    case apiTokenError
    case parsingError
    case responseError(AFError)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongEndpoint:
            return "네트워크 요청 HOST 주소가 맞지 않아요."
        case .wrongRequest:
            return "잘못된 요청이에요."
        case .parsingError:
            return "데이터 형식이 맞지 않아요."
        case .apiTokenError:
            return "API 요청 Token이 맞지 않아요."
        case let .responseError(error):
            return error.localizedDescription
        }
    }
}
