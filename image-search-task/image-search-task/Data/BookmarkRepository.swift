//
//  BookmarkRepository.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/03.
//

import CoreData
import RxSwift
import UIKit

protocol BookmarkRepositoryProtocol {
    func save(item: ImageItem)
    func remove(item: ImageItem)
    func loadAllBookmarkList() -> Single<[ImageEntity]>
    func removeAll()
}

struct BookmarkRepository: BookmarkRepositoryProtocol {
    private let coreDataStore = CoreDataStore.shared

    func save(item: ImageItem) {
        let context = coreDataStore.taskContext()

        /// 저장된 데이터가 없는 경우에만 객체 생성
        if fetch(url: item.url, context: context) == nil {
            let image = ImageEntity(context: context)
            image.url = item.url
            image.width = Int16(item.width)
            image.height = Int16(item.height)
            image.createdAt = Date()
        }

        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("[Core Data] save error \(error)")
            }
        }
    }

    func remove(item: ImageItem) {
        let context = coreDataStore.taskContext()
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(ImageEntity.url), item.url)

        do {
            try context.fetch(fetchRequest)
                .forEach {
                    context.delete($0)
                }
            try context.save()
        } catch {
            print("[Core Data] remove error \(error)")
        }
    }

    func loadAllBookmarkList() -> Single<[ImageEntity]> {
        Single<[ImageEntity]>.create { single -> Disposable in
            let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
            do {
                let entities = try coreDataStore.viewContext.fetch(fetchRequest)
                print(entities.map(\.url))
                print("=============")
                single(.success(entities))
            } catch {
                print("[Core Data] load all list error \(error)")
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    private func fetch(url: String, context: NSManagedObjectContext) -> ImageEntity? {
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(ImageEntity.url), url)

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print(error)
            return nil
        }
    }

    func removeAll() {
        let context = coreDataStore.taskContext()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: ImageEntity.fetchRequest())

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("[Core Data] removeAll error \(error)")
        }
    }
}
