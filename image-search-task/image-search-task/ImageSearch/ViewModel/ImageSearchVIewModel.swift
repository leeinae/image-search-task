//
//  ImageSearchVIewModel.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/02.
//

import RxCocoa
import RxSwift

final class ImageSearchViewModel {
    var imageList: [ImageItem] = []
    var bookmarkList: [Int] = []

    private let imageSearchUseCase: ImageSearchUseCase
    private let disposeBag = DisposeBag()

    init(imageSearchUseCase: ImageSearchUseCase) {
        self.imageSearchUseCase = imageSearchUseCase
    }

    struct Input {
        let didChangeImageSearchQuery: Observable<String>
        var selectedScopeIndex: Observable<Int>
    }

    struct Output {
        var didLoadData = PublishRelay<Bool>()
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.didChangeImageSearchQuery
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] keyword in
                self?.imageSearchUseCase.fetchImageSearchResult(query: keyword)
            }
            .disposed(by: disposeBag)

        imageSearchUseCase.resultList
            .subscribe(onNext: { [weak self] result in
                self?.imageList = result
                output.didLoadData.accept(true)
            })
            .disposed(by: disposeBag)

        return output
    }
}
