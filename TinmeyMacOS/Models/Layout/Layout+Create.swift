//
//  Layout+Create.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import Foundation
import TinmeyCore
import AppKit

extension Layout {
    struct Create {
        var title: String = ""
        var description: String = ""
        var images: [Image.Create] = []
    }
}

extension Layout.Create {
    init(_ layout: Layout) {
        self.init(
            title: layout.title,
            description: layout.description,
            images: layout.images.map(Layout.Image.Create.init)
        )
    }
}

extension Layout.Create: APIInput {
    var asAPIModel: LayoutAPIModel.Create {
        .init(
            title: title,
            description: description,
            images: images.asAPIModel
        )
    }
}

extension Layout.Create: Hashable { }
