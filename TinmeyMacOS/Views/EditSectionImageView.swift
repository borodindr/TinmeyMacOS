//
//  EditSectionImageView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import SwiftUI

struct EditSectionImageView: View {
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
    
    var body: some View {
        EditWorkItemContainer {
            if let imageURL = imageURL {
                AsyncImage(url: imageURL)
                    .aspectRatio(contentMode: .fit)
            } else {
                Spacer()
            }
        } controls: {
            Button(action: selectImage) {
                Text("Select image")
            }
            if newImagePath != nil && imagePath != nil {
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
            imagePath: nil,
            newImagePath: .constant(nil))
    }
}
