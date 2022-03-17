//
//  View+Extension.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 15.03.2022.
//

import SwiftUI
import UniformTypeIdentifiers

extension View {
    func selectFile(types: [UTType], completion: (URL) -> ()) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url {
            completion(url)
        }
    }
    
    func selectImage(completion: (URL) -> ()) {
        selectFile(types: [.image], completion: completion)
    }
}
