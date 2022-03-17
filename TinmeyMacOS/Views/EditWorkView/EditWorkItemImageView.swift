//
//  EditWorkImageItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditWorkItemImageView: View {
    @Binding var image: Work.Image.Create
    var onDeleteImage: () -> ()
    let onMoveLeft: (() -> ())?
    let onMoveRight: (() -> ())?
    
    var body: some View {
        EditWorkItemContainer {
            DropImage(droppedImageURL: $image.url)
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
            image.url = url
        }
    }
}

struct EditWorkItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkItemImageView(
            image: .constant(.init(.preview))) {
                
            } onMoveLeft: {
                
            } onMoveRight: {
                
            }
    }
}
