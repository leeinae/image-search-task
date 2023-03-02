//
//  SearchRepository.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/02.
//

import RxSwift

protocol SearchRepositoryProtocol {
    typealias ImageSearchResponse = ResponseModel<ImageSearchDTO>

    func fetchImageSearchResult(by query: String) -> Single<ImageSearchResponse>
}

struct SearchRepository: SearchRepositoryProtocol {
    func fetchImageSearchResult(by query: String) -> Single<ImageSearchResponse> {
        NetworkProvider.shared.request(
            SearchAPI.image(query),
            ImageSearchDTO.self
        ).map { $0 }
    }
}
