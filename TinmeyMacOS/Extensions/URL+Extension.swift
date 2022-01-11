//
//  URL+Extension.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 10.01.2022.
//

import Foundation

extension URL {
    func conforms(to identifier: String) -> Bool {
        let fileExt = pathExtension
        guard let uti = UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            fileExt as CFString,
            nil
        ) else {
            return false
        }
        return UTTypeConformsTo(
            uti.takeRetainedValue(),
            identifier as CFString
        )
    }
    
    func isImage() -> Bool {
        conforms(to: kUTTypeImage as String)
    }
}
