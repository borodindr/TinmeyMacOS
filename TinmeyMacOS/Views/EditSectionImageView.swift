//
//  EditSectionImageView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import SwiftUI

struct EditSectionImageView: View {
    let remoteImage: NSImage?
    @Binding var newImagePath: URL?
    private var displayImage: NSImage? {
        if let newImagePath = newImagePath,
            let newImage = NSImage(contentsOf: newImagePath) {
            return newImage
        }
        return remoteImage
    }
    
    var body: some View {
        EditWorkItemContainer {
            if let image = displayImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Spacer()
            }
        } controls: {
            Button(action: selectImage) {
                Text("Select image")
            }
            if newImagePath != nil && remoteImage != nil {
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
            newImagePath = url
        }
    }
    
    private func restoreImage() {
        newImagePath = nil
    }
}

struct EditSectionImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditSectionImageView(
            remoteImage: nil,
            newImagePath: .constant(nil))
    }
}
