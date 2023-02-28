//
//  ImageSearchViewController.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

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
            ResultItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ResultItemCollectionViewCell.identifier
        )
        view.dataSource = self
        return view
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: self.view.bounds.width, height: 100)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        100
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ResultItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ResultItemCollectionViewCell
        else { return UICollectionViewCell() }

        return cell
    }
}
