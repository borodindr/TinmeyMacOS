//
//  LayoutsAPIService.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import Foundation
import Combine
import Alamofire
import TinmeyCore

protocol LayoutsProviderService {
    init()
    
    func allLayouts() -> AnyPublisher<[Layout], Error>
    func create(newLayout: Layout.Create) -> AnyPublisher<Layout, Error>
    func update(layoutID: UUID, to newLayout: Layout.Create) -> AnyPublisher<Layout, Error>
    func delete(layoutID: UUID) -> AnyPublisher<Void, Error>
    func addImage(from fileURL: URL, to imageID: UUID) -> AnyPublisher<Void, Error>
    func deleteImage(imageID: UUID) -> AnyPublisher<Void, Error>
    func move(layoutID: UUID, newIndex: Int) -> AnyPublisher<Layout, Error>
    func swapImages(layoutID: UUID) -> AnyPublisher<Layout, Error>
}

class LayoutsAPIService: LayoutsProviderService {
    private let api = APIService(basePathComponents: "layouts")
    private let imagesService = APIService(basePathComponents: "layout_images")
    
    required init() { }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    
    
    func allLayouts() -> AnyPublisher<[Layout], Error> {
        api.get().map([Layout].init).eraseToAnyPublisher()
    }
    
    func create(newLayout: Layout.Create) -> AnyPublisher<Layout, Error> {
        api.post(body: newLayout.asAPIModel).map(Layout.init).eraseToAnyPublisher()
    }
    
    func update(layoutID: UUID, to newLayout: Layout.Create) -> AnyPublisher<Layout, Error> {
        api.put(layoutID.uuidString, body: newLayout.asAPIModel).map(Layout.init).eraseToAnyPublisher()
    }
    
    func delete(layoutID: UUID) -> AnyPublisher<Void, Error> {
        api.delete(layoutID.uuidString)
    }
    
    func addImage(from fileURL: URL, to imageID: UUID) -> AnyPublisher<Void, Error> {
        api.upload("images", imageID.uuidString, from: fileURL)
    }
    
    func deleteImage(imageID: UUID) -> AnyPublisher<Void, Error> {
        imagesService.delete(imageID.uuidString)
    }
    
    func loadImage(layoutImageID: UUID) -> AnyPublisher<Data, Error> {
        imagesService.download(layoutImageID.uuidString)
    }
    
    func move(layoutID: UUID, newIndex: Int) -> AnyPublisher<Layout, Error> {
        api.put(layoutID.uuidString, "move", "\(newIndex)")
    }
    
    func swapImages(layoutID: UUID) -> AnyPublisher<Layout, Error> {
        api.put(layoutID.uuidString, "swap")
    }
}


private extension LayoutsAPIService {
    enum ImageType: String {
        case firstImage, secondImage
    }
}


