//
//  APIModels.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 27.08.2021.
//

import TinmeyCore
import Foundation

struct Work {
    let id: UUID
    let title: String
    let description: String
    let tags: [String]
    let images: [Image]
}

extension Work: Identifiable { }
extension Work: Codable { }
extension Work: Hashable { }
extension Work: TaggedItemObject { }

extension Work: APIOutput {
    init(_ apiModel: WorkAPIModel) {
        self.init(
            id: apiModel.id,
            title: apiModel.title,
            description: apiModel.description,
            tags: apiModel.tags,
            images: apiModel.images.map(Image.init)
        )
    }
}

extension Work {
    static var preview: Work {
        Work(
            id: UUID(),
            title: "Title of the cover",
            description: "Some interesting description of the cover",
            tags: ["Some", "tag", "example"],
            images: [.preview, .preview]
        )
    }
}

extension Array where Element == Work {
    static var preview: [Work] { [.preview] }
}
