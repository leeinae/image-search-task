//
//  ImageItemCell.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import SDWebImage
import SnapKit
import UIKit

final class ImageItemCell: UICollectionViewCell {
    static let identifier = String(describing: ImageItemCell.self)

    private let thumbnailView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .gray
        return view
    }()

    private let bookmarkButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "bookmark"), for: .normal)
            button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        } else {
            button.setImage(UIImage(named: "bookmark"), for: .normal)
            button.setImage(UIImage(named: "bookmark.fill"), for: .selected)
        }
        button.tintColor = .black
        return button
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
        contentView.addSubviews([thumbnailView, bookmarkButton])

        thumbnailView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bookmarkButton.snp.top)
        }

        bookmarkButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.size.equalTo(44)
        }
    }

    func updateUI(_ model: ImageItem) {
        guard let url = URL(string: model.url)
        else { return }

        thumbnailView.sd_setImage(with: url)
    }
}
