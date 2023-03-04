//
//  ImageSearchViewController.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ImageSearchViewController: UIViewController {
    private let viewModel: ImageSearchViewModel
    private var disposeBag = DisposeBag()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.scopeButtonTitles = SearchBarCase.allCases.map(\.description)
        searchBar.placeholder = "검색할 이미지의 키워드를 입력하세요."
        searchBar.showsScopeBar = true
        return searchBar
    }()

    private lazy var imageListView = ImageListView(viewModel)
    private lazy var bookmarkListView = BookmarkListView(viewModel)

    init(_ viewModel: ImageSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        imageListView.viewWillTransition()
        super.viewWillTransition(to: size, with: coordinator)
    }

    private func setupUI() {
        view.addSubviews([searchBar, imageListView, bookmarkListView])

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        imageListView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        bookmarkListView.snp.makeConstraints { make in
            make.edges.equalTo(imageListView)
        }
    }

    private func bind() {
        let input = ImageSearchViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            didChangeImageSearchQuery: searchBar.rx.text.orEmpty.asObservable(),
            didTapBookmarkButton: nil,
            didChangeSelectedScopeButtonIndex: searchBar.rx.selectedScopeButtonIndex.asObservable(),
            didTapBookmarkEditButton: nil,
            selectedBookmarkCellRow: nil
        )

        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        output.willChangeSubView
            .subscribe(onNext: { [weak self] mode in
                self?.imageListView.isHidden = mode == .bookmark
                self?.bookmarkListView.isHidden = mode == .result
            })
            .disposed(by: disposeBag)

        output.willShowAlert
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
}

extension ImageSearchViewController {
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(
            title: "확인",
            style: .default
        )
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
}
