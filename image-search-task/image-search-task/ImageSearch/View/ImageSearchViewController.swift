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
            ImageItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageItemCollectionViewCell.identifier
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

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()

        NetworkProvider.shared.request(SearchImageAPI.searchImage("zz"), ImageSearchResponse.self)
            .subscribe(onDisposed: {})
            .disposed(by: disposeBag)
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
        searchBar.rx.selectedScopeButtonIndex
            .subscribe { [weak self] index in
                self?.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        searchBar.selectedScopeButtonIndex == 0 ? 100 : 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ImageItemCollectionViewCell
        else { return UICollectionViewCell() }

        return cell
    }
}
