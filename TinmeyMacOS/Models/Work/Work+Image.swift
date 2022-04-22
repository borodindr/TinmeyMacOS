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
        var url: URL? {
            guard let path = path else {
                return nil
            }
            return APIURLBuilder().path(path).buildURL()
        }
    }
}

extension Work.Image: Identifiable { }
extension Work.Image: Hashable { }
extension Work.Image: Codable { }
extension Work.Image: ImageObject { }

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
        .init(id: UUID(), path: nil)
    }
}
