//
//  EditBookCoverView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI

struct EditWorkView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: EditWorksViewModel
    init(work: Work?, availableTags: [String]) {
        self.viewModel = EditWorksViewModel(work: work, availableTags: availableTags)
    }
    
    var body: some View {
        ZStack {
//            ScrollView {
                VStack(alignment: .center, spacing: 8) {
                    title
                    images
                    fields
                    tags
                    controls
                }
                .padding()
//            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    ProgressIndicator(size: .regular)
                    Spacer()
                }
            }
        }
        .frame(minWidth: 450, maxWidth: 800, minHeight: 400)
        .background(BlurView())
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
                ForEach($viewModel.work.images, id: \.self) { $image in
                    EditWorkItemImageView(
                        remoteImage: image.currentImage,
                        newImageURL: $image.newImageURL,
                        onDeleteImage: { viewModel.work.images.removeAll(where: { $0 == image}) },
                        onMoveLeft: { moveImageForward(item: image) },
                        onMoveRight: { moveImageBackward(item: image) }
                    )
                }
                Button {
                    selectImage { url in
                        viewModel.work.images.append(.init(url: url))
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
            TextEditor(text: $viewModel.work.title)
                .roundedBorderTextView()
            TextEditor(text: $viewModel.work.description)
                .roundedBorderTextView()
        }
    }
    
    var tags: some View {
        HStack {
            TagInputView(tags: $viewModel.work.tags)
            TagSelectView(selectedTags: $viewModel.work.tags,
                          availableTags: viewModel.availableTags)
            Spacer()
        }
    }
    
    var controls: some View {
        HStack {
            Spacer()
            Button("Dismiss", action: dismiss.callAsFunction)
                .keyboardShortcut(.cancelAction)
            Button("Save") {
                viewModel.createOrUpdate(
                    completion: dismiss.callAsFunction
                )
            }
            .keyboardShortcut(.defaultAction)
        }
    }
    
    private func moveImageBackward(item: Work.Image.Create) {
        
    }
    
    private func moveImageForward(item: Work.Image.Create) {
        
    }
}



struct EditBookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditWorkView(work: .preview,
                         availableTags: ["Some", "tags", "data", "source"])
            
            EditWorkView(work: nil,
                         availableTags: ["Some", "tags", "data", "source"])
            
        }
    }
}
