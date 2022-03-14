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
    
    var items: [Item] {
        var items = images.map { Item.image($0) }
        items.insert(.body(self), at: 0)
        return items
    }
}

extension Work: Identifiable { }
extension Work: Codable { }
extension Work: Hashable { }

extension Work {
    typealias ReorderDirection = WorkAPIModel.ReorderDirection
}

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
    var twoDArray: [[Work.Item]] {
        let columns = 3
        var column = 0
        var columnIndex = 0
        var result = [[Work.Item]]()
        
        for object in items {
            if columnIndex < columns {
                if columnIndex == 0 {
                    result.insert([object], at: column)
                    columnIndex += 1
                } else {
                    result[column].append(object)
                    columnIndex += 1
                }
            } else {
                column += 1
                result.insert([object], at: column)
                columnIndex = 1
            }
        }
        return result
    }
    
}

extension Work {
    static var preview: Work {
        Work(
            id: .zero,
            title: "Title of the cover",
            description: "?Some interesting description of the cover",
            tags: ["Some", "tag", "example"],
            images: [.preview, .preview]
        )
    }
}

extension Work {
    var firstImageURL: URL? {
        baseImageURLBuilder.path("firstImage").buildURL()
    }
    
    var secondImageURL: URL? {
        baseImageURLBuilder.path("secondImage").buildURL()
    }
    
    private var baseImageURLBuilder: APIURLBuilder {
        let idString: String
        if id.uuidString == "00000000-0000-0000-0000-000000000000" {
            // For preview
            idString = "preview"
        } else {
            idString = id.uuidString
        }
        return APIURLBuilder.api()
            .path("works")
            .path(idString)
    }
}

extension Array where Element == Work {
    static var preview: [Work] { []
//        [.preview(layout: .leftBody),
//         .preview(layout: .middleBody),
//         .preview(layout: .rightBody),
//         .preview(layout: .leftLargeBody),
//         .preview(layout: .rightLargeBody)]
    }
    
}





extension SectionAPIModel {
    var firstImageURL: URL? {
        baseImageURLBuilder.path("firstImage").buildURL()
    }
    
    var secondImageURL: URL? {
        baseImageURLBuilder.path("secondImage").buildURL()
    }
    
    private var baseImageURLBuilder: APIURLBuilder {
        APIURLBuilder.api()
            .path("sections")
            .path(type.rawValue)
    }
}
