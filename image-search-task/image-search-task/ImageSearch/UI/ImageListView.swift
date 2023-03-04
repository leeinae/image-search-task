//
//  ImageListView.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/04.
//

import RxSwift
import UIKit

final class ImageListView: DefaultListView {
    override init(_ viewModel: ImageSearchViewModel) {
        super.init(viewModel)

        configureCollectionView()
        bind()
    }

    private func configureCollectionView() {
        collectionView.register(
            EmptyCell.self,
            forCellWithReuseIdentifier: EmptyCell.identifier
        )
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func bind() {
        let input = ImageSearchViewModel.Input(
            viewWillAppear: nil,
            didChangeImageSearchQuery: nil,
            didTapBookmarkButton: bookmarkButtonTapAction,
            didChangeSelectedScopeButtonIndex: nil,
            didTapBookmarkEditButton: nil,
            selectedBookmarkCellRow: nil
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

extension ImageListView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard viewModel?.visibleCellType != .empty else { return 1 }

        return viewModel?.imageList.count ?? .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cellType = viewModel?.visibleCellType else { return UICollectionViewCell() }

        switch cellType {
        case .image:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageItemCell.identifier,
                for: indexPath
            ) as? ImageItemCell,
                let viewModel = self.viewModel
            else { return UICollectionViewCell() }

            let imageItem = viewModel.imageList[indexPath.row]
            cell.updateUI(imageItem)
            cell.bindAction(imageItem)
                .bind(to: bookmarkButtonTapAction)
                .disposed(by: cell.disposeBag)

            return cell

        case .empty:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmptyCell.identifier,
                for: indexPath
            ) as? EmptyCell
            else { return UICollectionViewCell() }

            return cell
        }
    }
}

extension ImageListView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let viewModel else { return .zero }

        let cellType = viewModel.visibleCellType
        switch cellType {
        case .image:
            let item = viewModel.imageList[indexPath.row]
            let height = calcRatioHeight(width: item.width, height: item.height)

            return .init(width: UIScreen.main.bounds.width, height: height + 44)
        case .empty:
            return collectionView.bounds.size
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}
