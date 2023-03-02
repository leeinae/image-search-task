//
//  SearchImageAPI.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/01.
//

import Foundation

enum SearchAPI {
    case image(String)
}

extension SearchAPI: NetworkRequestable {
    var path: String {
        switch self {
        case .image:
            return "/v2/search/image"
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .image(query):
            return ["query": query]
        }
    }
}
