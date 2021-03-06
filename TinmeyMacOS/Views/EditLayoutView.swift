//
//  EditLayoutView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import SwiftUI

struct EditLayoutView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: EditLayoutsViewModel
    @State
    private var showDeleteAlert = false
    @State
    private var imageToDelete: Layout.Image.Create? = nil
    
    init(layout: Layout?) {
        self.viewModel = EditLayoutsViewModel(layout: layout)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            title
            ScrollView {
                images
                fields
            }
            HStack {
                Spacer()
                controls
            }
        }
        .padding()
        .dimmedLoading(viewModel.isLoading)
        .frame(minWidth: 450, maxWidth: 800, minHeight: 400, idealHeight: 600)
        .background(BlurView())
        .alert("Delete image?",
               isPresented: $showDeleteAlert,
               presenting: imageToDelete) { imageToDelete in
            Button("Delete", role: .destructive, action: {
                viewModel.layout.images.removeAll(where: { $0 == imageToDelete })
            })
        }
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.text),
                dismissButton: .default(Text("Close"))
            )
        }
    }
    
    // MARK: - Boxes
    var title: some View {
        Text(viewModel.title)
            .font(.title)
            .padding(.top, 16)
    }
    
    var images: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach($viewModel.layout.images, id: \.self) { $image in
                    EditItemImageView(
                        image: $image,
                        onDeleteImage: {
                            imageToDelete = image
                            showDeleteAlert.toggle()
                        },
                        onMoveLeft: viewModel.moveImageBackward(item: image),
                        onMoveRight: viewModel.moveImageForward(item: image)
                    )
                }
                Button {
                    selectImage { url in
                        viewModel.layout.images.append(.init(url: url))
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
                .frame(minHeight: 300)
            }
        }
    }
    
    var fields: some View {
        VStack {
            TextEditor(text: $viewModel.layout.title)
                .roundedBorderTextView()
                .frame(minHeight: 30)
            TextEditor(text: $viewModel.layout.description)
                .roundedBorderTextView()
                .frame(minHeight: 50)
        }
    }
    
    var controls: some View {
        HStack {
            Button("Dismiss", action: dismiss.callAsFunction)
                .keyboardShortcut(.cancelAction)
            Button("Save") {
                viewModel.save(
                    completion: dismiss.callAsFunction
                )
            }
            .keyboardShortcut(.defaultAction)
        }
    }
}



struct EditBookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditLayoutView(layout: .preview)
            
            EditLayoutView(layout: nil)
            
        }
    }
}

