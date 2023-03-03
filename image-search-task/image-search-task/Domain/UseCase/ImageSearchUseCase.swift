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
    var networkErrorMessage: PublishSubject<String> { get set }

    func fetchImageSearchResult(query: String)
}

final class ImageSearchUseCase: ImageSearchUseCaseProtocol {
    var resultList: PublishSubject<[ImageItem]> = .init()
    var networkErrorMessage: PublishSubject<String> = .init()

    private let searchRespository: SearchRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(searchRespository: SearchRepositoryProtocol) {
        self.searchRespository = searchRespository
    }

    func fetchImageSearchResult(query: String) {
        searchRespository.fetchImageSearchResult(by: query)
            .subscribe { [weak self] result in
                guard let self else { return }
                
                switch result {
                case let .success(data):
                    let imageList = data.documents.map { $0.toDomain() }
                    self.resultList.onNext(imageList)

                case let .failure(error):
                    let message = self.makeErrorMessage(error)
                    self.networkErrorMessage.onNext(message)
                }
            }
            .disposed(by: disposeBag)
    }

    private func makeErrorMessage(_ error: Error) -> String {
        guard let error = error as? NetworkError
        else { return "알 수 없는 에러가 발생했어요." }

        return error.localizedDescription
    }
}
