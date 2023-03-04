//
//  String+Extension.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/05.
//

import Foundation

extension String {
    var isContainsWhiteSpace: Bool {
        trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty
    }
}
