//
//  Work+Create.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import Foundation
import TinmeyCore
import AppKit

extension Work {
    struct Create {
        var title: String = ""
        var description: String = ""
        var tags: [String] = []
        var images: [Image.Create] = []
    }
}

extension Work.Create {
    init(_ work: Work) {
        self.init(
            title: work.title,
            description: work.description,
            tags: work.tags,
            images: work.images.map(Work.Image.Create.init)
        )
    }
}

extension Work.Create: APIInput {
    var asAPIModel: WorkAPIModel.Create {
        .init(
            title: title,
            description: description,
            tags: tags,
            images: images.asAPIModel
        )
    }
}

extension Work.Create: Hashable { }

extension Work.Image {
    struct Create {
        let id: UUID
        let isSaved: Bool
        var currentImageURL: URL?
        var currentImage: NSImage? = nil
        var newImageURL: URL? = nil
        
        init(
            id: UUID,
            isSaved: Bool,
            currentImagePath: String? = nil,
            currentImage: NSImage? = nil,
            newImageURL: URL? = nil
        ) {
            self.id = id
            self.isSaved = isSaved
            if let path = currentImagePath {
                self.currentImageURL = APIURLBuilder().path(path).buildURL()
            } else {
                self.currentImageURL = nil
            }
            self.currentImage = currentImage
            self.newImageURL = newImageURL
        }
    }
}

extension Work.Image.Create: Hashable { }
extension Work.Image.Create: Identifiable { }
extension Work.Image.Create: APIInput {
    var asAPIModel: WorkAPIModel.Image.Create {
        .init(id: isSaved ? id : nil)
    }
}

extension Work.Image.Create {
    init(_ image: Work.Image) {
        self.init(
            id: image.id,
            isSaved: true,
            currentImagePath: image.path,
            newImageURL: nil
        )
    }
    
    init(url: URL) {
        self.init(
            id: UUID(),
            isSaved: false,
            newImageURL: url
        )
    }
}

extension Work.Image.Create {
    static var clear: Self {
        Work.Image.Create(
            id: UUID(),
            isSaved: false,
            currentImagePath: nil,
            newImageURL: nil
        )
    }
    
    mutating func clear() {
        currentImageURL = nil
        currentImage = nil
        newImageURL = nil
    }
}
