//
//  APIModelConvertable.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import Foundation

protocol APIInput {
    associatedtype APIModel
    var asAPIModel: APIModel { get }
}

protocol APIOutput {
    associatedtype APIModel
    init(_ apiModel: APIModel)
}

extension Collection where Element: APIInput {
    var asAPIModel: [Element.APIModel] {
        map(\.asAPIModel)
    }
}

extension Array where Element: APIOutput {
    init(_ apiModels: [Element.APIModel]) {
        self = apiModels.map(Element.init)
    }
}

