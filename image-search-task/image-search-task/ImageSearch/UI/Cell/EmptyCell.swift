//
//  EmptyCell.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/04.
//

import UIKit

final class EmptyCell: UICollectionViewCell {
    static let identifier = String(describing: EmptyCell.self)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "검색 결과가 없어요"
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
