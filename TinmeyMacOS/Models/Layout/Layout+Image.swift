//
//  Layout+Image.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import Foundation
import TinmeyCore

extension Layout {
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

extension Layout.Image: Identifiable { }
extension Layout.Image: Hashable { }
extension Layout.Image: Codable { }
extension Layout.Image: ImageObject { }

extension Layout.Image: APIOutput {
    init(_ apiModel: LayoutAPIModel.Image) {
        self.init(
            id: apiModel.id,
            path: apiModel.path
        )
    }
}

extension Layout.Image {
    static func clear() -> Self {
        Layout.Image(id: UUID(), path: nil)
    }
}

extension Layout.Image {
    static var preview: Self {
        .init(id: UUID(), path: nil)
    }
}

