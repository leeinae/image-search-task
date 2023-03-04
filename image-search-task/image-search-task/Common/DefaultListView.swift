//
//  DefaultListView.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/05.
//

import RxSwift
import UIKit

class DefaultListView: UIView {
    private(set) weak var viewModel: ImageSearchViewModel?
    private(set) var bookmarkButtonTapAction = PublishSubject<ImageItem>()
    var disposeBag = DisposeBag()

    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionViewLayout
        )
        view.backgroundColor = .white
        view.register(
            ImageItemCell.self,
            forCellWithReuseIdentifier: ImageItemCell.identifier
        )
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()

    private(set) lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }()

    init(_ viewModel: ImageSearchViewModel) {
        super.init(frame: .zero)
        self.viewModel = viewModel

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewWillTransition() {
        resizeCells()
    }

    func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DefaultListView {
    func calcRatioHeight(width: CGFloat, height: CGFloat) -> CGFloat {
        guard !width.isZero else { return 100 }

        let ratio = UIScreen.main.bounds.width / width
        return height * ratio
    }

    func resizeCells() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            guard let _ = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                layout.itemSize = CGSize.zero
                return
            }

            layout.invalidateLayout()
        }
    }
}
