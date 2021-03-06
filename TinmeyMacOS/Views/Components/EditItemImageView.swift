//
//  EditImageItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditItemImageView<CreateImage: CreateImageObject>: View {
    @Binding var image: CreateImage
    var onDeleteImage: () -> ()
    let onMoveLeft: (() -> ())?
    let onMoveRight: (() -> ())?
    
    @State
    private var showDeleteAlert = false
    
    var body: some View {
        EditItemContainer {
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
//            .alert("Delete image?", isPresented: $showDeleteAlert) {
//                Button("Cancel", action: { showDeleteAlert.toggle() })
//                Button("Delete", action: onDeleteImage)
//            }
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

struct EditItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemImageView(
            image: .constant(Work.Image.Create(.preview))) {
                
            } onMoveLeft: {
                
            } onMoveRight: {
                
            }
    }
}
