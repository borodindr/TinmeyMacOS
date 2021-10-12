//
//  AlertType.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import Foundation

enum AlertType: Identifiable, Hashable {
    var id: AlertType { self }
    
    case error(message: String)
    case success(message: String)
    
    var title: String {
        switch self {
        case .error:
            return "Error"
        case .success:
            return "Success"
        }
    }
    
    var message: String {
        switch self {
        case .error(let message), .success(let message):
            return message
        }
    }
}
