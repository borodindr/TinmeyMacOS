//
//  ItemObject.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import Foundation

protocol ItemObject {
    associatedtype Image: ImageObject
    var id: UUID { get }
    var title: String { get }
    var description: String { get }
    var images: [Image] { get }
}

protocol TaggedItemObject: ItemObject {
    var tags: [String] { get }
}
