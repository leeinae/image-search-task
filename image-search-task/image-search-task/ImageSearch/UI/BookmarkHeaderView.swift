//
//  BookmarkHeaderView.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/04.
//

import RxSwift
import SnapKit
import UIKit

final class BookmarkHeaderView: UICollectionReusableView {
    static let identifier = String(String(describing: BookmarkListView.self))

    weak var viewModel: ImageSearchViewModel?
    var disposeBag = DisposeBag()

    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()

    private let finishButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.isEnabled = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

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
        addSubviews([editButton, finishButton])

        finishButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview().inset(12)
        }

        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(finishButton.snp.leading).offset(-12)
            make.centerY.equalTo(finishButton)
        }
    }

    func bindEditButtonAction() -> Observable<Bool> {
        editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.finishButton.isEnabled.toggle()
            })
            .disposed(by: disposeBag)

        return editButton.rx.tap.asObservable().map { [weak self] in
            self?.viewModel?.isBookmarkEditMode ?? false
        }
    }

    func bindFinishButtonAction() -> Observable<Void> {
        finishButton.rx.tap
            .map { false }
            .bind(to: finishButton.rx.isEnabled)
            .disposed(by: disposeBag)

        return finishButton.rx.tap.asObservable()
    }
}
