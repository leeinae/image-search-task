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

    private let searchRespository: SearchRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(searchRespository: SearchRepositoryProtocol) {
        self.searchRespository = searchRespository
    }

    func fetchImageSearchResult(query: String) {
        searchRespository.fetchImageSearchResult(by: query)
            .subscribe { [weak self] result in
                switch result {
                case let .success(data):
                    let imageList = data.documents.map { $0.toDomain() }
                    self?.resultList.onNext(imageList)
                case let .failure(error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
