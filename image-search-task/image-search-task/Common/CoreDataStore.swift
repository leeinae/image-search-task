//
//  CoreDataStore.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/03.
//

import Foundation
import CoreData

class CoreDataStore {
    static let shared = CoreDataStore()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageEntity")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func taskContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}
