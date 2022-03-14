//
//  AppSection.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import Foundation
import AppKit

enum AppSection {
    case works
    case layouts
    case settings
}

extension AppSection {
    var imageName: String {
        switch self {
        case .works:
            return "book.closed"
        case .layouts:
            return "book"
        case .settings:
            return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .works:
            return "Works"
        case .layouts:
            return "Book Layouts"
        case .settings:
            return "Settings"
        }
    }
    
}

extension AppSection: CaseIterable { }
extension AppSection: Hashable { }
