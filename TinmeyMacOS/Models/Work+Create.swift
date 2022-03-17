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
    enum Create {
        
        case remote(id: UUID, url: URL?)
        case local(url: URL)
        
        var url: URL? {
            get {
                switch self {
                case .remote(_, let url):
                    return url
                case .local(let url):
                    return url
                }
            }
            set {
                guard let newURL = newValue else {
                    print("Warning: Setting nil to localURL in Work.Image.Create is not supported.")
                    return
                }
                switch self {
                case .local:
                    self = .local(url: newURL)
                case .remote:
                    self = .init(url: newURL)
                }
            }
        }
    }
}

extension Work.Image.Create: Hashable { }
//extension Work.Image.Create: Identifiable {
//    var id: UUID {
//        switch self {
//        case .remote(let id, _, _), .local(let id, _):
//            return id
//        }
//    }
//}
extension Work.Image.Create: APIInput {
    var asAPIModel: WorkAPIModel.Image.Create {
        switch self {
        case .local:
            return .init(id: nil)
        case .remote(let id, _):
            return .init(id: id)
        }
    }
}

extension Work.Image.Create {
    init(_ image: Work.Image) {
        self = .remote(id: image.id, url: image.url)
    }
    
    init(url: URL) {
        self = .local(url: url)
    }
}

extension Work.Image.Create {
//    static var clear: Self {
//        Work.Image.Create(
//            id: UUID(),
//            currentImageURL: nil,
//            newImageURL: nil
//        )
//    }
    
//    mutating func clear() {
//        currentImageURL = nil
//        currentImage = nil
//        newImageURL = nil
//    }
}
