//
//  EditWorkImageItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditWorkItemImageView: View {
    let remoteImage: NSImage?
    @Binding var newImageURL: URL?
    private var image: NSImage? {
        if let newImageURL = newImageURL {
            return NSImage(contentsOf: newImageURL)
        }
        return remoteImage
    }
    var onClearImage: () -> ()
    let onMoveBackward: (() -> ())?
    let onMoveForward: (() -> ())?
    
    var body: some View {
        EditWorkItemContainer {
            DropImage(image, droppedImageURL: $newImageURL)
        } controls: {
            if let onMoveBackward = onMoveBackward {
                IconButton("arrow_left",
                           action: onMoveBackward)
            }
            
            Button(action: selectImage) {
                Text("Select image")
            }
            if newImageURL != nil && remoteImage != nil {
                Button(action: restoreImage) {
                    Text("Restore")
                }
            }
            if newImageURL != nil || remoteImage != nil {
                Button(action: onClearImage) {
                    Text("Clear")
                }
            }
            
            if let onMoveForward = onMoveForward {
                IconButton("arrow_right",
                           action: onMoveForward)
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

struct EditWorkItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkItemImageView(
            remoteImage: nil,
            newImageURL: .constant(nil)) {
                
            } onMoveBackward: {
                
            } onMoveForward: {
                
            }
    }
}
