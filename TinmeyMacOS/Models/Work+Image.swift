//
//  Work+Image.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import Foundation
import TinmeyCore

extension Work {
    struct Image {
        let id: UUID
        let path: String?
    }
}

extension Work.Image: Identifiable { }
extension Work.Image: Hashable { }
extension Work.Image: Codable { }

extension Work.Image: APIOutput {
    init(_ apiModel: WorkAPIModel.Image) {
        self.init(
            id: apiModel.id,
            path: apiModel.path
        )
    }
}

extension Work.Image {
    static func clear() -> Self {
        Work.Image(id: UUID(), path: nil)
    }
}

extension Work.Image {
    static var preview: Self {
        .init(id: .zero, path: nil)
    }
}
