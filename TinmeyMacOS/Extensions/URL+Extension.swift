//
//  URL+Extension.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 10.01.2022.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    func conforms(to contentType: UTType) -> Bool {
        guard let fileType = UTType(filenameExtension: pathExtension) else {
            return false
        }
        return fileType.conforms(to: contentType)
    }
    
    func isImage() -> Bool {
        conforms(to: UTType.image)
    }
}
