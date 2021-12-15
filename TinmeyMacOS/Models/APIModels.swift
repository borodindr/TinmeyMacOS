//
//  APIModels.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 27.08.2021.
//

import TinmeyCore
import Foundation

//typealias WorkType = WorkAPIModel.WorkType
typealias Work = WorkAPIModel

extension Work: Identifiable { }

//extension Work {
//    typealias LayoutType = LayoutTypeAPIModel
//}

extension Work {
    static var preview: Work {
        preview(layout: .leftBody)
    }
    
    static func preview(layout: Work.LayoutType) -> Work {
        Work(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            createdAt: Date(),
            updatedAt: Date(),
            title: "Title of the cover",
            description: "?Some interesting description of the cover\nNew line text",
            layout: layout,
            seeMoreLink: URL(string: "https://github.com"),
            tags: ["Some", "tag", "example"]
        )
    }
}
/*
 28DBFA32-C19A-4B8F-AF7B-5C229B50D53E
 00000000-0000-0000-0000-000000000000
 */

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
    static var preview: [Work] {
        [.preview(layout: .leftBody),
         .preview(layout: .middleBody),
         .preview(layout: .rightBody),
         .preview(layout: .leftLargeBody),
         .preview(layout: .rightLargeBody)]
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
