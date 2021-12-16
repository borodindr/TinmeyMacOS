//
//  Keychain.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import Foundation
import KeychainAccess
import Security

enum Keychain {
    private static var keychain: KeychainAccess.Keychain {
        KeychainAccess.Keychain(service: "Tinmey portfolio")
    }
    
    static func save(key: String, data: String) {
        keychain[key] = data
    }
    
    static func delete(key: String) {
        keychain[key] = nil
    }
    
    static func load(key: String) -> String? {
        keychain[key]
    }
}
