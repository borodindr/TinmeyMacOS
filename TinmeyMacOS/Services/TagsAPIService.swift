//
//  TagsAPIService.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import Combine
import Alamofire
import TinmeyCore

final class TagsAPIService {
    private let api = APIService(basePathComponents: "tags")
    
    func getAll() -> AnyPublisher<[String], Error> {
        api.get()
    }
}
