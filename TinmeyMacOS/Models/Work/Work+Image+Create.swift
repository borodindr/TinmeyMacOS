//
//  Work+Image+Create.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import Foundation
import TinmeyCore

extension Work.Image {
    enum Create {
        case remote(id: UUID, url: URL?)
        case local(url: URL)
    }
}

extension Work.Image.Create {
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

extension Work.Image.Create: Hashable { }
extension Work.Image.Create: CreateImageObject { }

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
