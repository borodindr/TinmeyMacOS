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
    func addFirstImage(from fileURL: URL, to workID: UUID) -> AnyPublisher<Void, Error>
    func addSecondImage(from fileURL: URL, to workID: UUID) -> AnyPublisher<Void, Error>
//    func loadImage(workImageID: UUID) -> AnyPublisher<Data, Error>
    func reorder(workID: UUID, direction: Work.ReorderDirection) -> AnyPublisher<Work, Error>
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
    
    func addFirstImage(from fileURL: URL, to workID: UUID) -> AnyPublisher<Void, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
    func addSecondImage(from fileURL: URL, to workID: UUID) -> AnyPublisher<Void, Error> {
        Fail(error: WorksPreviewError.notImplemented)
            .eraseToAnyPublisher()
    }
    
//    func loadImage(workImageID: UUID) -> AnyPublisher<Data, Error> {
//        Fail(error: WorksPreviewError.notImplemented)
//            .eraseToAnyPublisher()
//    }
    
    func reorder(workID: UUID, direction: Work.ReorderDirection) -> AnyPublisher<Work, Error> {
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
    
    private let api = APIService(basePathComponents: "works")
    private var getAllWorksParameters: AllWorksParameters {
        AllWorksParameters(type: workType)
    }
    
    required init(workType: Work.WorkType) {
        self.workType = workType
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    
    
    func allWorks() -> AnyPublisher<[Work], Error> {
        api.get(query: getAllWorksParameters)
    }
    
    func create(newWork: Work.Create) -> AnyPublisher<Work, Error> {
        api.post(body: newWork)
    }
    
    func update(workID: UUID, to newWork: Work.Create) -> AnyPublisher<Work, Error> {
        api.put(workID.uuidString, body: newWork)    }
    
    func delete(workID: UUID) -> AnyPublisher<Void, Error> {
        api.delete(workID.uuidString)
    }
    
    func addFirstImage(from fileURL: URL, to workID: UUID) -> AnyPublisher<Void, Error> {
        addImage(.firstImage, from: fileURL, to: workID)
    }
    
    func addSecondImage(from fileURL: URL, to workID: UUID) -> AnyPublisher<Void, Error> {
        addImage(.secondImage, from: fileURL, to: workID)
    }
    
    func loadImage(workImageID: UUID) -> AnyPublisher<Data, Error> {
        api.download("images", workImageID.uuidString)
    }
    
    func reorder(workID: UUID, direction: Work.ReorderDirection) -> AnyPublisher<Work, Error> {
        api.put(workID.uuidString, "reorder", direction.rawValue)
    }
    
    private func addImage(_ imageType: ImageType, from fileURL: URL, to workID: UUID) -> AnyPublisher<Void, Error> {
        api.upload(workID.uuidString, imageType.rawValue,
                   from: fileURL,
                   withName: "picture")
    }
}


private extension WorksAPIService {
    enum ImageType: String {
        case firstImage, secondImage
    }
}

