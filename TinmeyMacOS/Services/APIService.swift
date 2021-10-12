//
//  APIService.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import Foundation
import Combine
import Alamofire

enum APIError: Error, LocalizedError {
    case afError(AFError)
    case vaporError(VaporError)
    
    var errorDescription: String? {
        switch self {
        case .afError(let error):
            return error.localizedDescription
        case .vaporError(let error):
            return error.reason
        }
    }
}

struct VaporError: Error, Decodable {
    let error: Bool
    let reason: String?
}

final class APIService {
    let basePathComponents: [String]
    
    var baseURL: String {
        "http://127.0.0.1:8080/api" + basePathComponents.reduce("") { $0 + "/\($1)" }
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    private var authHeader: HTTPHeader? {
        guard let token = AuthAPIService.token else { return nil }
        return HTTPHeader.authorization(bearerToken: token)
    }
    
    init(basePathComponents: String...) {
        self.basePathComponents = basePathComponents
    }
    
    private func buildURL(adding pathComponents: [String]) -> String {
        baseURL + pathComponents.reduce("") { $0 + "/\($1)" }
    }
    
    private func buildHeaders(adding additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers = HTTPHeaders()
        if let authHeader = authHeader {
            headers.add(authHeader)
        }
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach {
                headers.add($0)
            }
        }
        return headers
    }
    
    // MARK: GET dictionary
    func get<T>(
        _ pathComponents: String...,
        query: [String: Any]? = nil,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable {
        AF
            .request(
                buildURL(adding: pathComponents),
                method: .get,
                parameters: query,
                headers: buildHeaders(adding: additionalHeaders)
            )
            .publishDecodable(decoder: decoder)
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: Error.self)
            .flatMap { $0.result.publisher }
            .eraseToAnyPublisher()
    }
    
    // MARK: - GET Encodable
    func get<T, Parameters>(
        _ pathComponents: String...,
        query: Parameters,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable, Parameters: Encodable {
        AF
            .request(
                buildURL(adding: pathComponents),
                method: .get,
                parameters: query,
                headers: buildHeaders(adding: additionalHeaders)
            )
            .publishDecodable(decoder: decoder)
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: Error.self)
            .flatMap { $0.result.publisher }
            .eraseToAnyPublisher()
    }
    
    // MARK: - POST
    func post<T>(
        _ pathComponents: String...,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable {
        AF
            .request(
                buildURL(adding: pathComponents),
                method: .post,
                headers: buildHeaders(adding: additionalHeaders)
            )
            .publishDecodable(decoder: decoder)
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: Error.self)
            .flatMap { $0.result.publisher }
            .eraseToAnyPublisher()
    }
    
    func post<T, Body>(
        _ pathComponents: String...,
        body: Body? = nil,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable, Body: Encodable {
        AF
            .request(
                buildURL(adding: pathComponents),
                method: .post,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: buildHeaders(adding: additionalHeaders)
            )
            .publishDecodable(decoder: decoder)
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: Error.self)
            .flatMap { $0.result.publisher }
            .eraseToAnyPublisher()
    }
    
    // MARK: - PUT
    func put<T, Body>(
        _ pathComponents: String...,
        body: Body? = nil,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable, Body: Encodable {
        AF
            .request(
                buildURL(adding: pathComponents),
                method: .put,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: buildHeaders(adding: additionalHeaders)
            )
            .publishDecodable(decoder: decoder)
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: Error.self)
            .flatMap { $0.result.publisher }
            .eraseToAnyPublisher()
    }
    
    func put<T>(
        _ pathComponents: String...,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable {
        AF
            .request(
                buildURL(adding: pathComponents),
                method: .put,
                headers: buildHeaders(adding: additionalHeaders)
            )
            .publishDecodable(decoder: decoder)
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: Error.self)
            .flatMap { $0.result.publisher }
            .eraseToAnyPublisher()
    }
    
    
    // MARK: - DELETE
    func delete(
        _ pathComponents: String...,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<Void, Error> {
        AF
            .request(
                buildURL(adding: pathComponents),
                method: .delete,
                headers: buildHeaders(adding: additionalHeaders)
            )
            .validate(statusCode: 200..<300)
            .publishUnserialized()
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: APIError.self)
            .flatMap { $0.result.publisher }
            .mapError { $0 }
            .map { data in () }
            .eraseToAnyPublisher()
    }
    
    // MARK: - UPLOAD
    func upload(
        _ pathComponents: String...,
        from fileURL: URL,
        withName name: String,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<Void, Error> {
        AF
            .upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(fileURL, withName: name)
                },
                to: buildURL(adding: pathComponents),
                headers: buildHeaders(adding: additionalHeaders)
            )
            .validate(statusCode: 200..<300)
            .publishUnserialized()
            .map { response in
                response.mapError { error -> APIError in
                    if let data = response.data,
                        let vaporError = try? JSONDecoder().decode(VaporError.self, from: data) {
                        return APIError.vaporError(vaporError)
                    }
                    return APIError.afError(error)
                }
                
            }
            .setFailureType(to: APIError.self)
            .flatMap { $0.result.publisher }
            .mapError { $0 }
            .map { data in () }
            .eraseToAnyPublisher()
    }
    
    // MARK: - DOWNLOAD
    func download(
        _ pathComponents: String...,
        additionalHeaders: HTTPHeaders? = nil
    ) -> AnyPublisher<Data, Error> {
        AF
            .download(
                buildURL(adding: pathComponents),
                headers: buildHeaders(adding: additionalHeaders)
            )
            .publishData()
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
