//
//  APIURLBuilder.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.10.2021.
//

import Foundation

struct APIURLBuilder {
    static var endpoint: URL = {
        guard let endpointString = InfoPlist.getValue(forKey: "API_ENDPOINT") else {
            fatalError("Api endpoint was not set in user-defined Build Settings. Please set it for key 'API_ENDPOINT'.")
        }
        guard let endpoint = URL(string: endpointString) else {
            fatalError("Provided value for 'API_ENDPOINT' in Build Settings is not valid URL.")
        }
        return endpoint
    }()
    
    private var paths: [String] = []
    
    static func api() -> Self {
        Self().path("api")
    }
    
    func buildURL() -> URL {
        paths.reduce(Self.endpoint) { $0.appendingPathComponent($1) }
    }
    
    func path(_ path: String) -> Self {
        var builder = self
        builder.paths.append(path)
        return builder
    }
    
    func paths(_ paths: [String]) -> Self {
        paths.reduce(self) { $0.path($1) }
    }
    
}
