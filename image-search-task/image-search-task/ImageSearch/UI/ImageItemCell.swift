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

    override var isSelected: Bool {
        willSet {
            self.setSelected(newValue)
        }
    }

    private let thumbnailView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        return view
    }()

    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic-check"), for: .selected)
        button.setImage(UIImage(named: "ic-uncheck"), for: .normal)
        button.isHidden = true
        button.isUserInteractionEnabled = false
        return button
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

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        view.isHidden = true
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

    override func prepareForReuse() {
        thumbnailView.image = nil
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func setupUI() {
        contentView.addSubviews([thumbnailView, bookmarkButton, checkButton])
        thumbnailView.addSubview(overlayView)

        thumbnailView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bookmarkButton.snp.top)
        }

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.size.equalTo(44)
        }

        checkButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
    }

    func updateUI(_ model: ImageItem) {
        guard let url = URL(string: model.url) else { return }

        bookmarkButton.isSelected = model.isBookmark
        checkButton.isHidden = model.isHiddenCheckButton
        thumbnailView.sd_setImage(with: url) { [weak self] image, error, _, _ in
            if error != nil {
                self?.thumbnailView.image = UIImage(named: "ic-broken")
            } else {
                self?.thumbnailView.image = image
            }
        }
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

    private func setSelected(_ isSelected: Bool) {
        self.overlayView.isHidden = !isSelected
        self.checkButton.isSelected = isSelected
        self.checkButton.isHidden = false
    }
}
