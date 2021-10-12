//
//  AuthAPIService.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import Combine
import Alamofire
import TinmeyCore
import SwiftUI

final class AuthAPIService {
    private let api = APIService(basePathComponents: "users")
    
    func login(username: String, password: String) -> AnyPublisher<UserAPIModel, Error> {
        let basicAuthHeader = HTTPHeader.authorization(username: username, password: password)
        let additionalHeaders = HTTPHeaders([basicAuthHeader])
        return api.post("login", additionalHeaders: additionalHeaders)
            .map { (result: UserAPIModel.LoginResult) in
                Self.token = result.token
                return result.user
            }
            .eraseToAnyPublisher()
    }
    
    func logout() {
        AuthAPIService.token = nil
    }
    
    func change(
        currentPassword: String,
        to newPassword: String,
        repeatNewPassword: String
    ) -> AnyPublisher<UserAPIModel, Error> {
        let changePasswordParams = UserAPIModel.ChangePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            repeatNewPassword: repeatNewPassword
        )
        return api.put("changePassword", body: changePasswordParams)
    }
    
}

extension AuthAPIService {
    static var token: String? {
        get {
            Keychain.load(key: tokenKey)
        } set {
            if let token = newValue {
                Keychain.save(key: tokenKey, data: token)
            } else {
                Keychain.delete(key: tokenKey)
            }
        }
    }
    
    static var isAuthorized: Bool {
        token != nil
    }
    
    private static var tokenKey = "TINMEY-API-KEY"
}
