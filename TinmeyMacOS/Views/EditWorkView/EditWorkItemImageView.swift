//
//  EditWorkImageItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditWorkItemImageView: View {
    let imagePath: String?
    @Binding var newImagePath: URL?
    private var imageURL: URL? {
        if let newImagePath = newImagePath {
            return newImagePath
        }
        if let path = imagePath {
            return APIURLBuilder().path(path).buildURL()
        }
        return nil
    }
    var onClearImage: () -> ()
    let onMoveBackward: (() -> ())?
    let onMoveForward: (() -> ())?
    
    var body: some View {
        EditWorkItemContainer {
            if let imageURL = imageURL {
                AsyncImage(url: imageURL)
                    .aspectRatio(contentMode: .fit)
            } else {
                Spacer()
            }
        } controls: {
            if let onMoveBackward = onMoveBackward {
                IconButton("arrow_left",
                           action: onMoveBackward)
            }
            
            Button(action: selectImage) {
                Text("Select image")
            }
            if newImagePath != nil && imagePath != nil {
                Button(action: restoreImage) {
                    Text("Restore")
                }
            }
            if newImagePath != nil || imagePath != nil {
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
            newImagePath = url
        }
    }
    
    private func restoreImage() {
        newImagePath = nil
    }
}

struct EditWorkItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkItemImageView(
            imagePath: nil,
            newImagePath: .constant(nil)) {
                
            } onMoveBackward: {
                
            } onMoveForward: {
                
            }
    }
}
