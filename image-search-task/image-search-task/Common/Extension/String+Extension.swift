//
//  String+Extension.swift
//  image-search-task
//
//  Created by inae Lee on 2023/03/05.
//

import Foundation

extension String {
    func trim() -> Self {
        trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
