//
//  ImageEntity+CoreDataClass.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/03.
//
//

import CoreData
import Foundation

@objc(ImageEntity)
public class ImageEntity: NSManagedObject {}

extension ImageEntity {
    func toDomain() -> ImageItem {
        .init(
            url: url ?? "",
            width: CGFloat(width),
            height: CGFloat(height),
            isBookmark: true
        )
    }
}
