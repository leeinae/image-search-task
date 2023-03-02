//
//  ResponseModel.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/02.
//

import Foundation

struct ResponseModel<T: Decodable>: Decodable {
    let meta: MetaData
    let documents: [T]
}

struct MetaData: Decodable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}
