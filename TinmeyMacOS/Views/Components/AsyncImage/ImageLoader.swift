//
//  ImageLoader.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 31.08.2021.
//

import Foundation
import Combine
import SwiftUI
import Alamofire

class ImageLoader: ObservableObject {
    @Published var image: NSImage?
    private let url: URL?
    private var imageLoadSubscription: AnyCancellable?
    
    init(url: URL?) {
        self.url = url
        load()
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard let url = url else { return }
        imageLoadSubscription = AF.request(url)
            .publishData()
            .value()
            .map { NSImage(data: $0) }
            .replaceError(with: nil)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        imageLoadSubscription?.cancel()
    }
}
