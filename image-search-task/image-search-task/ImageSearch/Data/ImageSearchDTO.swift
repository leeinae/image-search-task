//
//  ImageSearchResponse.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/02.
//

import Foundation

struct ImageSearchDTO: Decodable {
    let collection: String?
    let thumbnailURL: String?
    let imageURL: String?
    let width: Int?
    let height: Int?
    let displaySiteName: String?
    let docURL: String?
    let datetime: String?

    enum CodingKeys: String, CodingKey {
        case collection, width, height, datetime
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case displaySiteName = "display_sitename"
        case docURL = "doc_url"
    }

    func toDomain() -> ImageItem {
        .init(
            url: imageURL ?? "",
            displayName: displaySiteName ?? "",
            width: CGFloat(width ?? 0),
            height: CGFloat(height ?? 0)
        )
    }
}
