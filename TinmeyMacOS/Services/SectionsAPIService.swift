//
//  SectionsAPIService.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import Foundation
import Combine
import Alamofire
import TinmeyCore

final class SectionsAPIService {
    private let api = APIService(basePathComponents: "sections")
    
    func getSection(ofType sectionType: SectionAPIModel.SectionType) -> AnyPublisher<SectionAPIModel, Error> {
        api.get(sectionType.rawValue)
    }
    
    func updateSection(_ newSection: SectionAPIModel) -> AnyPublisher<SectionAPIModel, Error> {
        api.put(newSection.type.rawValue, body: newSection)
    }
    
    func addFirstImage(
        from fileURL: URL,
        for sectionType: SectionAPIModel.SectionType
    ) -> AnyPublisher<Void, Error> {
        addImage(.firstImage, from: fileURL, for: sectionType)
    }
    
    func addSecondImage(
        from fileURL: URL,
        for sectionType: SectionAPIModel.SectionType
    ) -> AnyPublisher<Void, Error> {
        addImage(.secondImage, from: fileURL, for: sectionType)
    }
    
    private func addImage(
        _ imageType: ImageType,
        from fileURL: URL,
        for sectionType: SectionAPIModel.SectionType
    ) -> AnyPublisher<Void, Error> {
        api.upload(sectionType.rawValue, imageType.rawValue,
                   from: fileURL,
                   withName: "picture")
    }
}

private extension SectionsAPIService {
    enum ImageType: String {
        case firstImage, secondImage
    }
}
