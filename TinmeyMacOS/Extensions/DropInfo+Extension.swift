//
//  DropInfo+Extension.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 10.01.2022.
//

import SwiftUI
import UniformTypeIdentifiers

extension DropInfo {
    enum LoadError: Error {
        case wrongIdentifierType
    }
    
    private var types: [UTType] {
        [.fileURL]
    }
    
    @discardableResult
    func loadFileURL(completionHandler: @escaping (Result<URL, Error>) -> ()) -> Bool {
        let providers = itemProviders(for: types)
        
        guard let item = providers.first,
               item.canLoadObject(ofClass: URL.self) else {
                  completionHandler(.failure(LoadError.wrongIdentifierType))
                  return false
              }
        
        _ = item.loadObject(ofClass: URL.self) { url, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                guard let url = url else { return }
                completionHandler(.success(url))
            }
        }
        return true
    }
}
