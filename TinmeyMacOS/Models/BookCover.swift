//
//  BookCover.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import Foundation

struct BookCover: Codable, Hashable {
    let title: String
    let description: String
}

extension BookCover {
    static var preview = BookCover(title: "Title", description: "Description")
}
