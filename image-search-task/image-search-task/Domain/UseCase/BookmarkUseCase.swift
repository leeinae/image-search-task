//
//  BookmarkUseCase.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/03.
//

import Foundation
import RxSwift

protocol BookmarkUseCaseProtocol {
    var bookmarkList: PublishSubject<[ImageItem]> { get set }

    func fetchBookmarkList()
    func save(with item: ImageItem)
    func remove(with item: ImageItem)
    func removeItems(items: [ImageItem])
}

final class BookmarkUseCase: BookmarkUseCaseProtocol {
    var bookmarkList: RxSwift.PublishSubject<[ImageItem]> = .init()

    private let bookmarkRepository: BookmarkRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(bookmarkRepository: BookmarkRepositoryProtocol) {
        self.bookmarkRepository = bookmarkRepository
    }

    func fetchBookmarkList() {
        bookmarkRepository.loadAllBookmarkList()
            .subscribe { [weak self] result in
                switch result {
                case let .success(data):
                    let bookmarkedList = data.map { $0.toDomain() }
                    self?.bookmarkList.onNext(bookmarkedList)
                case let .failure(error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }

    func save(with item: ImageItem) {
        bookmarkRepository.save(item: item)
    }

    func remove(with item: ImageItem) {
        bookmarkRepository.remove(item: item)
    }

    func removeItems(items: [ImageItem]) {
        items.forEach { self.remove(with: $0) }

        fetchBookmarkList()
    }

    func removeAll() {
        bookmarkRepository.removeAll()
    }
}
