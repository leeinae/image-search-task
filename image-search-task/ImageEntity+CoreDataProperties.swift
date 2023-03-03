//
//  ImageEntity+CoreDataProperties.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/04.
//
//

import CoreData
import Foundation

public extension ImageEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged var height: Int16
    @NSManaged var url: String?
    @NSManaged var width: Int16
    @NSManaged var createdAt: Date?
}
