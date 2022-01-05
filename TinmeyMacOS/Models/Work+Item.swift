//
//  Work+Item.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import Foundation
import TinmeyCore

extension Work {
    enum Item {
        case body(Work)
        case image(Work.Image)
    }
}

extension Work.Item: Hashable { }
extension Work.Item: Codable { }

extension Work.Item: Identifiable {
    public var id: UUID {
        switch self {
        case .body(let data):
            return data.id
        case .image(let data):
            return data.id
        }
    }
}

extension Work.Item {
    var isBody: Bool {
        switch self {
        case .body:
            return true
        case .image:
            return false
        }
    }
}

extension Work.Item {
    static var previewClear: Self {
        .image(.init(id: .zero, path: nil))
    }
    
    static var previewBody: Self {
        .body(.preview)
    }
    
    static var previewImage: Self {
        .image(.init(id: .zero, path: ""))
    }
}
