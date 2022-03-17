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
    var onDeleteImage: () -> ()
    let onMoveLeft: (() -> ())?
    let onMoveRight: (() -> ())?
    
    var body: some View {
        EditWorkItemContainer {
            DropImage(image, droppedImageURL: $newImageURL)
        } controls: {
            VStack {
                Spacer()
            
                HStack(spacing: 24) {
                    if needArrows {
                        HStack(spacing: 8) {
                            if let onMoveLeft = onMoveLeft {
                                IconButton("arrow.left", action: onMoveLeft)
                            }
                            
                            if let onMoveRight = onMoveRight {
                                IconButton("arrow.right", action: onMoveRight)
                            }
                        }
                    }
                    
                    IconButton("square.and.pencil", action: selectImage)
                    IconButton("trash", action: onDeleteImage)
                        .foregroundColor(.red)
                    
                    if newImageURL != nil && remoteImage != nil {
                        Button(action: restoreImage) {
                            Text("Restore")
                        }
                    }
                    
                }
            }
            .padding()
        }
    }
    
    private var needArrows: Bool {
        onMoveLeft != nil || onMoveRight != nil
    }
    
    private func selectImage() {
        selectImage { url in
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
                
            } onMoveLeft: {
                
            } onMoveRight: {
                
            }
    }
}
