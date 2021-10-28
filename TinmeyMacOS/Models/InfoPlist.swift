//
//  InfoPlist.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.10.2021.
//

import Foundation

enum InfoPlist {
    static func getValue(forKey key: String) -> String? {
        Bundle.main.infoDictionary?[key] as? String
    }
}
