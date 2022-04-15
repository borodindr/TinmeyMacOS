//
//  Layout.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import TinmeyCore
import Foundation

struct Layout {
    let id: UUID
    let title: String
    let description: String
    let images: [Image]
}

extension Layout: Identifiable { }
extension Layout: Codable { }
extension Layout: Hashable { }
extension Layout: ItemObject { }

extension Layout: APIOutput {
    init(_ apiModel: LayoutAPIModel) {
        self.init(
            id: apiModel.id,
            title: apiModel.title,
            description: apiModel.description,
            images: apiModel.images.map(Image.init)
        )
    }
}

extension Layout {
    static var preview: Layout {
        Layout(
            id: UUID(),
            title: "Title of the cover",
            description: "Some interesting description of the cover",
            images: [.preview, .preview]
        )
    }
}

extension Array where Element == Layout {
    static var preview: [Layout] { [.preview] }
}
