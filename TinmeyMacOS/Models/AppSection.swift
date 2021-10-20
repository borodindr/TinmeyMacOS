//
//  AppSection.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import Foundation

enum AppSection {
    case home
    case covers
    case layouts
    case settings
}

extension AppSection {
    var imageName: String {
        switch self {
        case .home:
            return "house"
        case .covers:
            return "book"
        case .layouts:
            return "book_closed"
        case .settings:
            return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .covers:
            return "Book Covers"
        case .layouts:
            return "Book Layouts"
        case .settings:
            return "Settings"
        }
    }
    
}

extension AppSection: CaseIterable { }
extension AppSection: Hashable { }