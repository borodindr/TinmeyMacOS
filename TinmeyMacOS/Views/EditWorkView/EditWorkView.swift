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
    @State
    private var showDeleteAlert = false
    @State
    private var imageToDelete: Work.Image.Create? = nil
    
    init(work: Work?, availableTags: [String]) {
        self.viewModel = EditWorksViewModel(work: work, availableTags: availableTags)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            title
            ScrollView {
                images
                fields
                tagsList
            }
            HStack {
                tagsControls
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
                viewModel.work.images.removeAll(where: { $0 == imageToDelete })
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
                ForEach($viewModel.work.images, id: \.self) { $image in
                    EditWorkItemImageView(
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
                .frame(minHeight: 30)
            TextEditor(text: $viewModel.work.description)
                .roundedBorderTextView()
                .frame(minHeight: 50)
        }
    }
    
    var tagsList: some View {
        TagsListView(tags: viewModel.work.tags) { tagToDelete in
            guard let indexToDelete = viewModel.work.tags.firstIndex(of: tagToDelete) else {
                return
            }
            viewModel.work.tags.remove(at: indexToDelete)
        }
    }
    
    var tagsControls: some View {
        HStack {
            TagInputView(tags: $viewModel.work.tags)
            TagSelectView(selectedTags: $viewModel.work.tags,
                          availableTags: viewModel.availableTags)
            Spacer()
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
            EditWorkView(work: .preview,
                         availableTags: ["Some", "tags", "data", "source"])
            
            EditWorkView(work: nil,
                         availableTags: ["Some", "tags", "data", "source"])
            
        }
    }
}
