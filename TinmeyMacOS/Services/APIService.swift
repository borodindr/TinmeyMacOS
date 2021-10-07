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
    
    init(basePathComponents: String...) {
        self.basePathComponents = basePathComponents
    }
    
    private func buildURL(adding pathComponents: [String]) -> String {
        baseURL + pathComponents.reduce("") { $0 + "/\($1)" }
    }
    
    // MARK: GET dictionary
    func get<T>(
        _ pathComponents: String...,
        query: [String: Any]?
    ) -> AnyPublisher<T, APIError> where T: Decodable {
        get(pathComponents, query: query)
    }
    
    func get<T>(
        _ pathComponents: [String] = [],
        query: [String: Any]?
    ) -> AnyPublisher<T, APIError> where T: Decodable {
        AF.request(buildURL(adding: pathComponents), method: .get, parameters: query)
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
            .setFailureType(to: APIError.self)
            .flatMap({ $0.result.publisher })
//            .value()
//            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - GET Encodable
    func get<T, Parameters>(
        _ pathComponents: String...,
        query: Parameters
    ) -> AnyPublisher<T, Error> where T: Decodable, Parameters: Encodable {
        get(pathComponents, query: query)
    }
    
    func get<T, Parameters>(
        _ pathComponents: [String] = [],
        query: Parameters
    ) -> AnyPublisher<T, Error> where T: Decodable, Parameters: Encodable {
        AF.request(buildURL(adding: pathComponents), method: .get, parameters: query)
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
            .flatMap({ $0.result.publisher })
//            .value()
//            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    // POST
    func post<T, Body>(
        _ pathComponents: String...,
        body: Body
    ) -> AnyPublisher<T, Error> where T: Decodable, Body: Encodable {
        post(pathComponents, body: body)
    }
    
    func post<T, Body>(
        _ pathComponents: [String] = [],
        body: Body
    ) -> AnyPublisher<T, Error> where T: Decodable, Body: Encodable {
        AF.request(buildURL(adding: pathComponents), method: .post, parameters: body, encoder: JSONParameterEncoder.default)
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
            .flatMap({ $0.result.publisher })
//            .value()
//            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    // PUT
    func put<T, Body>(
        _ pathComponents: String...,
        body: Body? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable, Body: Encodable {
        put(pathComponents, body: body)
    }
    
    func put<T, Body>(
        _ pathComponents: [String] = [],
        body: Body? = nil
    ) -> AnyPublisher<T, Error> where T: Decodable, Body: Encodable {
        AF.request(buildURL(adding: pathComponents), method: .put, parameters: body, encoder: JSONParameterEncoder.default)
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
            .flatMap({ $0.result.publisher })
//            .value()
//            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func put<T>(
        _ pathComponents: String...
    ) -> AnyPublisher<T, Error> where T: Decodable {
        put(pathComponents)
    }
    
    func put<T>(
        _ pathComponents: [String] = []
    ) -> AnyPublisher<T, Error> where T: Decodable {
        AF.request(buildURL(adding: pathComponents), method: .put)
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
            .flatMap({ $0.result.publisher })
//            .value()
//            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    
    // DELETE
    func delete(
        _ pathComponents: String...
    ) -> AnyPublisher<Void, Error> {
        delete(pathComponents)
    }
    
    func delete(
        _ pathComponents: [String] = []
    ) -> AnyPublisher<Void, Error> {
        AF.request(buildURL(adding: pathComponents), method: .delete)
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
            .flatMap({ $0.result.publisher })
//            .value()
            .mapError { $0 }
            .map { data in () }
            .eraseToAnyPublisher()
    }
    
    // UPLOAD
    func upload(
        _ pathComponents: String...,
        from fileURL: URL,
        withName name: String
    ) -> AnyPublisher<Void, Error> {
        upload(pathComponents, from: fileURL, withName: name)
    }
    
    func upload(
        _ pathComponents: [String] = [],
        from fileURL: URL,
        withName name: String
    ) -> AnyPublisher<Void, Error> {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileURL, withName: name)
        }, to: buildURL(adding: pathComponents))
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
            .flatMap({ $0.result.publisher })
//            .value()
            .mapError { $0 }
            .map { data in () }
            .print("upload")
            .eraseToAnyPublisher()
    }
    
    // DOWNLOAD
    func download(
        _ pathComponents: String...
    ) -> AnyPublisher<Data, Error> {
        download(pathComponents)
    }
    
    func download(
        _ pathComponents: [String] = []
    ) -> AnyPublisher<Data, Error> {
        AF.download(buildURL(adding: pathComponents))
            .publishData()
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
