//
//  ResultItemCollectionViewCell.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import SnapKit
import UIKit

final class ResultItemCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ResultItemCollectionViewCell.self)

    private let thumbnailView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubviews([thumbnailView])

        thumbnailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
