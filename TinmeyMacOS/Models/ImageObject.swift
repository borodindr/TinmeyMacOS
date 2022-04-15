//
//  ImageObject.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import Foundation

protocol ImageObject {
    var id: UUID { get }
    var path: String? { get }
    var url: URL? { get }
}
