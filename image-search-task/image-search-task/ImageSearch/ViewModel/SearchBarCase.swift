//
//  SearchBarCase.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import Foundation

enum SearchBarCase: Int, CaseIterable {
    case result
    case bookmark
}

extension SearchBarCase: CustomStringConvertible {
    var description: String {
        switch self {
        case .result: return "검색 결과"
        case .bookmark: return "북마크"
        }
    }
}
