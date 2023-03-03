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
    var bookmarkList: [ImageItem] = []

    private let imageSearchUseCase: ImageSearchUseCaseProtocol
    private let bookmarkUseCase: BookmarkUseCaseProtocol

    private let disposeBag = DisposeBag()

    init(
        imageSearchUseCase: ImageSearchUseCaseProtocol,
        bookmarkUseCase: BookmarkUseCaseProtocol
    ) {
        self.imageSearchUseCase = imageSearchUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let didChangeImageSearchQuery: Observable<String>
        let didTapBookmarkButton: Observable<ImageItem>
        let didChangeSelectedScopeButtonIndex: Observable<Int>
    }

    struct Output {
        var didLoadData = PublishRelay<Bool>()
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.bookmarkUseCase.fetchBookmarkList()
            })
            .disposed(by: disposeBag)

        input.didChangeSelectedScopeButtonIndex
            .subscribe(onNext: {  _ in
                output.didLoadData.accept(true)
            })
            .disposed(by: disposeBag)

        input.didChangeImageSearchQuery
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] keyword in
                self?.imageSearchUseCase.fetchImageSearchResult(query: keyword)
            }
            .disposed(by: disposeBag)

        input.didTapBookmarkButton
            .subscribe(onNext: { [weak self] item in
                item.isBookmark ? self?.bookmarkUseCase.remove(with: item) : self?.bookmarkUseCase.save(with: item)
                self?.bookmarkUseCase.fetchBookmarkList()
            }).disposed(by: disposeBag)

        imageSearchUseCase.resultList
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }

                self.imageList = self.convertedBookmarkImage(result, self.bookmarkList)
                output.didLoadData.accept(true)
            })
            .disposed(by: disposeBag)

        bookmarkUseCase.bookmarkList
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }

                let bookmarkedImageList = self.convertedBookmarkImage(self.imageList, result)
                self.imageList = bookmarkedImageList
                self.bookmarkList = result
            })
            .disposed(by: disposeBag)

        return output
    }

    private func convertedBookmarkImage(_ images: [ImageItem], _ bookmarkList: [ImageItem]) -> [ImageItem] {
        images.map { item -> ImageItem in
            let isBookmark = bookmarkList.contains(where: { item.url == $0.url })
            return .init(url: item.url, width: item.width, height: item.height, isBookmark: isBookmark)
        }
    }
}
