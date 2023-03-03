//
//  BookmarkListView.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/04.
//

import RxSwift
import UIKit

final class BookmarkListView: UIView {
    private weak var viewModel: ImageSearchViewModel?
    private let bookmarkButtonTapAction = PublishSubject<ImageItem>()
    private var disposeBag = DisposeBag()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        view.register(
            ImageItemCell.self,
            forCellWithReuseIdentifier: ImageItemCell.identifier
        )
        view.register(
            BookmarkHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BookmarkHeaderView.identifier
        )
        view.dataSource = self
        view.delegate = self
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    init(_ viewModel: ImageSearchViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel

        setupUI()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bind() {
        let input = ImageSearchViewModel.Input(
            viewWillAppear: nil,
            didChangeImageSearchQuery: nil,
            didTapBookmarkButton: bookmarkButtonTapAction,
            didChangeSelectedScopeButtonIndex: nil
        )

        let output = viewModel?.transform(from: input, disposeBag: disposeBag)
        output?.didLoadData
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension BookmarkListView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel?.bookmarkList.count ?? .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageItemCell.identifier,
            for: indexPath
        ) as? ImageItemCell,
            let viewModel = self.viewModel
        else { return UICollectionViewCell() }

        let imageItem = viewModel.bookmarkList[indexPath.row]
        cell.updateUI(imageItem)
        cell.bindAction(imageItem)
            .bind(to: bookmarkButtonTapAction)
            .disposed(by: cell.disposeBag)

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: BookmarkHeaderView.identifier,
                  for: indexPath
              ) as? BookmarkHeaderView
        else { return UICollectionReusableView() }

        return header
    }
}

extension BookmarkListView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let viewModel else { return .zero }

        let item = viewModel.bookmarkList[indexPath.row]
        let height = calcRatioHeight(width: item.width, height: item.height)

        return .init(width: UIScreen.main.bounds.width, height: height + 44)
    }

    private func calcRatioHeight(width: CGFloat, height: CGFloat) -> CGFloat {
        guard !width.isZero else { return 100 }

        let ratio = UIScreen.main.bounds.width / width
        return height * ratio
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}
