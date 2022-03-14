//
//  Work+Create.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import Foundation
import TinmeyCore
import AppKit

extension Work {
    struct Create {
        var title: String
        var description: String
        var tags: [String]
        var images: [Image.Create]
    }
}

extension Work.Create {
    init(_ work: Work) {
        self.init(
            title: work.title,
            description: work.description,
            tags: work.tags,
            images: work.images.map(Work.Image.Create.init)
        )
    }
    
    init() {
        self.init(
            title: "",
            description: "",
            tags: [],
            images: [.clear, .clear]
        )
    }
}

extension Work.Create: APIInput {
    var asAPIModel: WorkAPIModel.Create {
        .init(
            title: title,
            description: description,
            tags: tags,
            images: images.asAPIModel
        )
    }
}

extension Work.Create: Hashable { }
extension Work.Create: Identifiable {
    var id: Self {
        self
    }
}

extension Work.Create {
    var twoDArray: [[Work.Item.Create]] {
        get {
            makeTwoDArray()
        }
        set {
            updateFromTwoDArray(newValue)
        }
    }
    
    private func makeTwoDArray() -> [[Work.Item.Create]] {
        var list: [Work.Item.Create] = images.map { .image($0) }
        list.insert(.body, at: 0)
        
        let columns = 3
        
        var column = 0
        var columnIndex = 0
        var result = [[Work.Item.Create]]()
        
        for object in list {
            if columnIndex < columns {
                if columnIndex == 0 {
                    result.insert([object], at: column)
                    columnIndex += 1
                } else {
                    result[column].append(object)
                    columnIndex += 1
                }
            } else {
                column += 1
                result.insert([object], at: column)
                columnIndex = 1
            }
        }
        return result
    }
    
    private mutating func updateFromTwoDArray(_ twoDArray: [[Work.Item.Create]]) {
        var array = twoDArray.flatMap { $0 }
        guard let bodyIndex = array.firstIndex(of: .body) else {
            fatalError("Attempted to update EditWork without body item: \(String(describing: twoDArray))")
        }
        array.remove(at: bodyIndex)
        let images = array.map { item -> Work.Image.Create in
            guard case let .image(image) = item else {
                fatalError("Attempted to update EditWork multiple body item: \(String(describing: twoDArray))")
            }
            return image
        }
        self.images = images
    }
    
    var canRemoveRow: Bool {
        true
    }
    
    mutating func addRow() {
        images.append(contentsOf: [.clear, .clear, .clear])
    }
    
    mutating func removeRow() {
        guard canRemoveRow else {
            print("Attempted to remove rows with body or the last row.", String(describing: self))
            return
        }
        let newCount = images.count - 3
        while images.count > newCount {
            images.removeLast()
        }
    }
}

extension Work.Image {
    struct Create {
        let id: UUID
        let isSaved: Bool
        var currentImageURL: URL?
        var currentImage: NSImage? = nil
        var newImageURL: URL? = nil
        
        init(
            id: UUID,
            isSaved: Bool,
            currentImagePath: String? = nil,
            currentImage: NSImage? = nil,
            newImageURL: URL? = nil
        ) {
            self.id = id
            self.isSaved = isSaved
            if let path = currentImagePath {
                self.currentImageURL = APIURLBuilder().path(path).buildURL()
            } else {
                self.currentImageURL = nil
            }
            self.currentImage = currentImage
            self.newImageURL = newImageURL
        }
    }
}

extension Work.Image.Create: Hashable { }
extension Work.Image.Create: Identifiable { }
extension Work.Image.Create: APIInput {
    var asAPIModel: WorkAPIModel.Image.Create {
        .init(id: isSaved ? id : nil)
    }
}

extension Work.Image.Create {
    init(_ image: Work.Image) {
        self.init(
            id: image.id,
            isSaved: true,
            currentImagePath: image.path,
            newImageURL: nil
        )
    }
}

extension Work.Image.Create {
    static var clear: Self {
        Work.Image.Create(
            id: UUID(),
            isSaved: false,
            currentImagePath: nil,
            newImageURL: nil
        )
    }
    
    mutating func clear() {
        currentImageURL = nil
        currentImage = nil
        newImageURL = nil
    }
}

extension Work.Item {
    enum Create {
        case body
        case image(Work.Image.Create)
    }
}

extension Work.Item.Create: Hashable { }
extension Work.Item.Create: Identifiable {
    var id: Work.ID {
        switch self {
        case .body:
            return .zero
        case .image(let data):
            return data.id
        }
    }
}
