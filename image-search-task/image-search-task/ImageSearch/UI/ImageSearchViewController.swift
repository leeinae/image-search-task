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
    var viewModel: ImageSearchViewModel
    private let bookmarkButtonTapAction = PublishSubject<ImageItem>()
    private let disposeBag = DisposeBag()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.scopeButtonTitles = SearchBarCase.allCases.map(\.description)
        searchBar.placeholder = "검색할 이미지의 키워드를 입력하세요."
        searchBar.showsScopeBar = true
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        view.register(
            ImageItemCell.self,
            forCellWithReuseIdentifier: ImageItemCell.identifier
        )
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

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

    private func setupUI() {
        view.addSubviews([searchBar, collectionView])

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bind() {
        let input = ImageSearchViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            didChangeImageSearchQuery: searchBar.rx.text.orEmpty.asObservable(),
            didTapBookmarkButton: bookmarkButtonTapAction,
            didChangeSelectedScopeButtonIndex: searchBar.rx.selectedScopeButtonIndex.asObservable()
        )

        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        output.didLoadData
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        searchBar.selectedScopeButtonIndex == 0 ? viewModel.imageList.count : viewModel.bookmarkList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageItemCell.identifier,
            for: indexPath
        ) as? ImageItemCell
        else { return UICollectionViewCell() }

        let scopeCase = SearchBarCase(rawValue: searchBar.selectedScopeButtonIndex)
        let imageItem = scopeCase == .result ? viewModel.imageList[indexPath.row] : viewModel.bookmarkList[indexPath.row]
        cell.updateUI(imageItem)
        cell.bindAction(imageItem)
            .bind(to: bookmarkButtonTapAction)
            .disposed(by: cell.disposeBag)

        return cell
    }
}

extension ImageSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let scopeCase = SearchBarCase(rawValue: searchBar.selectedScopeButtonIndex)

        var item: ImageItem
        switch scopeCase {
        case .result:
            item = viewModel.imageList[indexPath.row]
        case .bookmark:
            item = viewModel.bookmarkList[indexPath.row]
        case .none:
            return .zero
        }
        let height = calcRatioHeight(width: item.width, height: item.height)

        return .init(width: UIScreen.main.bounds.width, height: height + 44)
    }

    private func calcRatioHeight(width: CGFloat, height: CGFloat) -> CGFloat {
        guard !width.isZero else { return 100 }

        let ratio = UIScreen.main.bounds.width / width
        return height * ratio
    }
}
