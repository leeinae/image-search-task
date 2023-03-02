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
        return view
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: self.view.bounds.width, height: 100 + 44)
        return layout
    }()

    init(_ viewModel: ImageSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

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
            didChangeImageSearchQuery: searchBar.rx.text.orEmpty.asObservable(),
            selectedScopeIndex: searchBar.rx.selectedScopeButtonIndex.asObservable()
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
        return searchBar.selectedScopeButtonIndex == 0 ? viewModel.imageList.count : 0
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

        return cell
    }
}
