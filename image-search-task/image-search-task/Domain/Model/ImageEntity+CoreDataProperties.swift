//
//  ImageEntity+CoreDataProperties.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/03.
//
//

import CoreData
import Foundation

public extension ImageEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged var url: String?
    @NSManaged var datetime: Date?
    @NSManaged var width: Int16
    @NSManaged var height: Int16
}
