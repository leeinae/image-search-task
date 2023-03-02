//
//  ImageSearchUseCase.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/02.
//

import Foundation
import RxSwift

protocol ImageSearchUseCaseProtocol {
    var resultList: PublishSubject<[ImageItem]> { get set }

    func fetchImageSearchResult(query: String)
}

final class ImageSearchUseCase: ImageSearchUseCaseProtocol {
    var resultList: PublishSubject<[ImageItem]> = .init()

    private let searchService: SearchRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(searchService: SearchRepositoryProtocol) {
        self.searchService = searchService
    }

    func fetchImageSearchResult(query: String) {
        searchService.fetchImageSearchResult(by: query)
            .subscribe { [weak self] result in
                print(result)
                switch result {
                case let .success(model):
                    self?.resultList.onNext(model.documents.map { $0.toDomain() })
                case let .failure(error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
