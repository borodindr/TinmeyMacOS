//
//  BookCoversAPIService.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import Foundation
import Combine
import Alamofire
import TinmeyCore

protocol WorksProviderService {
    var workType: Work.WorkType { get }
    
    init(workType: Work.WorkType)
    
    func allWorks() -> AnyPublisher<[Work], Error>
    func create(newWork: Work.Create) -> AnyPublisher<Work, Error>
    func update(workID: UUID, to newWork: Work.Create) -> AnyPublisher<Work, Error>
    func delete(workID: UUID) -> AnyPublisher<Void, Error>
    func addImage(from fileURL: URL, to imageID: UUID) -> AnyPublisher<Void, Error>
    func deleteImage(imageID: UUID) -> AnyPublisher<Void, Error>
    func reorder(workID: UUID, direction: Work.ReorderDirection) -> AnyPublisher<Work, Error>
    func swapImages(workID: UUID) -> AnyPublisher<Work, Error>
}

class WorksPreviewService: WorksProviderService {
    enum WorksPreviewError: Error {
        case notImplemented
    }
    
    let workType: Work.WorkType
    
    required init(workType: Work.WorkType) {
        self.workType = workType
    }
    
    func allWorks() -> AnyPublisher<[Work], Error> {
        Just([Work].preview)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func create(newWork: Work.Create) -> AnyPublisher<Work, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
    func update(workID: UUID, to newWork: Work.Create) -> AnyPublisher<Work, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
    func delete(workID: UUID) -> AnyPublisher<Void, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
    func addImage(from fileURL: URL, to imageID: UUID) -> AnyPublisher<Void, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
    func deleteImage(imageID: UUID) -> AnyPublisher<Void, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
    func reorder(workID: UUID, direction: Work.ReorderDirection) -> AnyPublisher<Work, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
    func swapImages(workID: UUID) -> AnyPublisher<Work, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
}

class WorksAPIService: WorksProviderService {
    private struct AllWorksParameters: Codable {
        let type: Work.WorkType
    }
    
    private struct ReorderParameters: Encodable {
        let direction: Work.ReorderDirection
    }
    
    let workType: Work.WorkType
    
    private let api: APIService//(basePathComponents: "works")
    private let imagesService = APIService(basePathComponents: "work_images")
    private var getAllWorksParameters: AllWorksParameters {
        AllWorksParameters(type: workType)
    }
    
    required init(workType: Work.WorkType) {
        self.workType = workType
        self.api = APIService(basePathComponents: workType.rawValue)
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    
    
    func allWorks() -> AnyPublisher<[Work], Error> {
        api.get(query: getAllWorksParameters).map([Work].init).eraseToAnyPublisher()
    }
    
    func create(newWork: Work.Create) -> AnyPublisher<Work, Error> {
        api.post(body: newWork.asAPIModel).map(Work.init).eraseToAnyPublisher()
    }
    
    func update(workID: UUID, to newWork: Work.Create) -> AnyPublisher<Work, Error> {
        api.put(workID.uuidString, body: newWork.asAPIModel).map(Work.init).eraseToAnyPublisher()
    }
    
    func delete(workID: UUID) -> AnyPublisher<Void, Error> {
        api.delete(workID.uuidString)
    }
    
    func addImage(from fileURL: URL, to imageID: UUID) -> AnyPublisher<Void, Error> {
        imagesService.upload(imageID.uuidString, from: fileURL)
    }
    
    func deleteImage(imageID: UUID) -> AnyPublisher<Void, Error> {
        imagesService.delete(imageID.uuidString)
    }
    
    func loadImage(workImageID: UUID) -> AnyPublisher<Data, Error> {
        imagesService.download(workImageID.uuidString)
    }
    
    func reorder(workID: UUID, direction: WorkAPIModel.ReorderDirection) -> AnyPublisher<Work, Error> {
        api.put(workID.uuidString, "reorder", direction.rawValue)
    }
    
    func swapImages(workID: UUID) -> AnyPublisher<Work, Error> {
        api.put(workID.uuidString, "swap")
    }
}


private extension WorksAPIService {
    enum ImageType: String {
        case firstImage, secondImage
    }
}

