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
    var visibleCellType: CellType = .image
    var isBookmarkEditMode: Bool = false

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
        let viewWillAppear: Observable<Void>?
        let didChangeImageSearchQuery: Observable<String>?
        let didTapBookmarkButton: Observable<ImageItem>?
        let didChangeSelectedScopeButtonIndex: Observable<Int>?
        let didTapBookmarkEditButton: Observable<Bool>?
        let selectedBookmarkCellRow: Observable<[Int]>?
    }

    struct Output {
        var didLoadData = PublishRelay<Bool>()
        var willShowAlert = PublishRelay<String>()
        var willChangeSubView = BehaviorRelay<SearchBarCase>(value: .result)
        var bookmarkEditMode = BehaviorRelay<Bool>(value: false)
    }

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.viewWillAppear?
            .subscribe(onNext: { [weak self] in
                self?.bookmarkUseCase.fetchBookmarkList()
            })
            .disposed(by: disposeBag)

        input.didChangeSelectedScopeButtonIndex?
            .subscribe(onNext: { index in
                let mode = SearchBarCase(rawValue: index) ?? .result
                output.willChangeSubView.accept(mode)
                output.didLoadData.accept(true)
            })
            .disposed(by: disposeBag)

        input.didChangeImageSearchQuery?
            .filter { !$0.isEmpty }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] keyword in
                self?.imageSearchUseCase.fetchImageSearchResult(query: keyword)
            }
            .disposed(by: disposeBag)

        input.didTapBookmarkButton?
            .subscribe(onNext: { [weak self] item in
                item.isBookmark ? self?.bookmarkUseCase.remove(with: item) : self?.bookmarkUseCase.save(with: item)
                self?.bookmarkUseCase.fetchBookmarkList()
            }).disposed(by: disposeBag)

        input.didTapBookmarkEditButton?
            .subscribe(onNext: { [weak self] flag in
                self?.isBookmarkEditMode = !flag
                output.bookmarkEditMode.accept(!flag)
            })
            .disposed(by: disposeBag)

        input.selectedBookmarkCellRow?
            .subscribe(onNext: { [weak self] selectedRows in
                guard let self else { return }

                let items = selectedRows.compactMap { self.bookmarkList[$0] }
                self.bookmarkUseCase.removeItems(items: items)
                self.isBookmarkEditMode = false
            })
            .disposed(by: disposeBag)

        imageSearchUseCase.resultList
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }

                self.imageList = self.convertedBookmarkImage(result, self.bookmarkList)
                self.visibleCellType = result.isEmpty ? .empty : .image
                output.didLoadData.accept(true)
            })
            .disposed(by: disposeBag)

        imageSearchUseCase.networkErrorMessage
            .bind(to: output.willShowAlert)
            .disposed(by: disposeBag)

        bookmarkUseCase.bookmarkList
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }

                let bookmarkedImageList = self.convertedBookmarkImage(self.imageList, result)
                self.imageList = bookmarkedImageList
                self.bookmarkList = result.sorted(by: { $0.datetime > $1.datetime })
                output.didLoadData.accept(true)
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
