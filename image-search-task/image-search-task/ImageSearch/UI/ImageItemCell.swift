//
//  ImageItemCell.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import RxCocoa
import RxSwift
import SDWebImage
import SnapKit
import UIKit

final class ImageItemCell: UICollectionViewCell {
    static let identifier = String(describing: ImageItemCell.self)
    var disposeBag = DisposeBag()

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

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
        guard let url = URL(string: model.url) else { return }

        thumbnailView.sd_setImage(with: url)
        bookmarkButton.isSelected = model.isBookmark
    }

    func bindAction(_ model: ImageItem) -> Observable<ImageItem> {
        bookmarkButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.bookmarkButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)

        return bookmarkButton.rx.tap.compactMap { [weak self] _ in
            guard let self else { return nil }

            return ImageItem(
                url: model.url,
                width: model.width,
                height: model.height,
                isBookmark: !self.bookmarkButton.isSelected
            )
        }
    }
}
