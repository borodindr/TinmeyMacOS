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
