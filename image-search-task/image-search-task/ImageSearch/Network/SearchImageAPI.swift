//
//  SearchImageAPI.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/01.
//

import Foundation

enum SearchImageAPI {
    case searchImage(String)
}

extension SearchImageAPI: NetworkRequestable {
    var path: String {
        switch self {
        case .searchImage:
            return "/v2/search/image"
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .searchImage(query):
            return ["query": query]
        }
    }
}
