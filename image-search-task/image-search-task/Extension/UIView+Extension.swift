//
//  UIView+Extension.swift
//  image-search-task
//
//  Created by inae Lee on 2023/02/28.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
