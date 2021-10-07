//
//  APIModels.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 27.08.2021.
//

import TinmeyCore
import Foundation

typealias WorkType = WorkTypeAPIModel
typealias Work = WorkAPIModel

extension Work: Identifiable { }

extension Work {
    typealias LayoutType = LayoutTypeAPIModel
}

extension Work {
    static var preview: Work {
        preview(layout: .leftBody)
    }
    
    static func preview(layout: LayoutTypeAPIModel) -> Work {
        Work(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            createdAt: Date(),
            updatedAt: Date(),
            title: "Title of the cover",
            description: "Some interesting description of the cover",
            layout: layout,
            seeMoreLink: URL(string: "https://github.com")
        )
    }
}
/*
 28DBFA32-C19A-4B8F-AF7B-5C229B50D53E
 00000000-0000-0000-0000-000000000000
 */

extension Work {
    var firstImageURL: URL? {
        let urlString = baseImageURLString + "/firstImage"
        return URL(string: urlString)
    }
    
    var secondImageURL: URL? {
        let urlString = baseImageURLString + "/secondImage"
        return URL(string: urlString)
    }
    
    private var baseImageURLString: String {
        let idString: String
        if id.uuidString == "00000000-0000-0000-0000-000000000000" {
            // For preview
            idString = "preview"
        } else {
            idString = id.uuidString
        }
        return "http://127.0.0.1:8080/api/works/" + idString
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

//extension Work.Short {
//    static var preview = Work.Short(id: UUID(), createdAt: Date(), updatedAt: Date(), title: "Title", shortDescription: "Short Description", imageID: nil)
//
//    var imageURL: URL? {
//        guard let imageID = imageID else {
//            return nil
//        }
//        let urlString = "http://127.0.0.1:8080/api/works/images/\(imageID.uuidString)"
//        return URL(string: urlString)
//    }
//}
