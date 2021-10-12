//
//  ProfileAPIService.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import Combine
import Alamofire
import TinmeyCore

final class ProfileAPIService {
    private let api = APIService(basePathComponents: "profile")
    
    func getProfile() -> AnyPublisher<ProfileAPIModel, Error> {
        api.get()
    }
    
    func update(to newProfile: ProfileAPIModel) -> AnyPublisher<ProfileAPIModel, Error> {
        api.put(body: newProfile)
    }
}
