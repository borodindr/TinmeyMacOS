//
//  EditSectionImageView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import SwiftUI

struct EditSectionImageView: View {
    let remoteImage: NSImage?
    @Binding var newImageURL: URL?
    private var image: NSImage? {
        if let newImageURL = newImageURL,
            let newImage = NSImage(contentsOf: newImageURL) {
            return newImage
        }
        return remoteImage
    }
    
    var body: some View {
        EditWorkItemContainer {
            DropImage(image, droppedImageURL: $newImageURL)
        } controls: {
            Button(action: selectImage) {
                Text("Select image")
            }
            if newImageURL != nil && remoteImage != nil {
                Button(action: restoreImage) {
                    Text("Restore")
                }
            }
        }
    }
    
    private func selectImage() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url {
            newImageURL = url
        }
    }
    
    private func restoreImage() {
        newImageURL = nil
    }
}

struct EditSectionImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditSectionImageView(
            remoteImage: nil,
            newImageURL: .constant(nil))
    }
}
