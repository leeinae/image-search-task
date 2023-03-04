//
//  ImageItem.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/02.
//

import Foundation

struct ImageItem: Equatable {
    let url: String
    let width: CGFloat
    let height: CGFloat
    var isBookmark: Bool = false
    var datetime = Date()
    var isHiddenCheckButton: Bool = true

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url
    }
}
