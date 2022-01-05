//
//  Array+Extension.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import Foundation

extension Array where Element: Identifiable {
    subscript(id: Element.ID) -> Element? {
        get {
            first { $0.id == id }
        }
        set {
            guard let index = firstIndex(where: { $0.id == id }) else { return }
            remove(at: index)
            if let newValue = newValue {
                insert(newValue, at: index)
            }
        }
    }
}

extension Array where Element: Equatable {
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
    }
}

extension Array {
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}

extension Array: Identifiable where Element: Identifiable {
    public var id: [Element.ID] {
        map { $0.id }
    }
    
}
