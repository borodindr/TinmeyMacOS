//
//  EditBookCoverView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI

struct EditWorkView: View {
    @ObservedObject private var viewModel: EditWorksViewModel
    
    init(editWork: Binding<EditWork?>, availableTags: [String]) {
        self.viewModel = EditWorksViewModel(editWork: editWork, availableTags: availableTags)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 8) {
                Text(viewModel.title)
                    .font(.title)
                    .padding(.top, 16)
                
                boxes
                
                TextField("See work link", text: $viewModel.seeMoreLink)
                
                HStack {
                    TagInputView(onSave: viewModel.addTag)
                    TagSelectView(availableTags: viewModel.availableTags,
                                  onSelect: viewModel.addTag)
                    Spacer()
                }
                
                HStack {
                    Button(action: {
                        viewModel.editWork = nil
                    }, label: {
                        Text("Dismiss")
                    })
                    Spacer()
                    Button(action: {
                        viewModel.createOrUpdate()
                    }, label: {
                        Text("Save")
                    })
                }
            }
            .padding()
            
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    ProgressIndicator(size: .regular)
                    Spacer()
                }
            }
        }
        .frame(minWidth: 1000, minHeight: 400)
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
    var boxes: some View {
        HStack(spacing: 0) {
            switch viewModel.editWork?.layout {
            case .leftBody:
                bodyBox
                firstImageBox
                secondImageBox
                
            case .middleBody:
                firstImageBox
                bodyBox
                secondImageBox
                
            case .rightBody:
                firstImageBox
                secondImageBox
                bodyBox
                
            case .leftLargeBody:
                largeBodyBox
                firstImageBox
                
            case .rightLargeBody:
                firstImageBox
                largeBodyBox
                
            case .none:
                Text("Error!")
            }
        }
    }
    
    var bodyBox: some View {
        VStack(spacing: 8) {
            EditWorkViewBodyBox(title: $viewModel.titleText,
                                description: $viewModel.descriptionText,
                                tags: viewModel.tags,
                                needSeeMoreLink: viewModel.seeMoreLink != "",
                                onTagDelete: viewModel.deleteTag)
                .background(Color.black)
                .border(Color.gray, width: 1)
            bodyBoxControls
        }
    }
    
    var largeBodyBox: some View {
        VStack(spacing: 8) {
            HStack {
                EditWorkViewBodyBox(title: $viewModel.titleText,
                                    description: $viewModel.descriptionText,
                                    tags: viewModel.tags,
                                    needSeeMoreLink: viewModel.seeMoreLink != "",
                                    onTagDelete: viewModel.deleteTag)
                Spacer()
            }
            .frame(width: 600, height: 300)
            .background(Color.black)
            .border(Color.gray, width: 1)
            bodyBoxControls
        }
    }
    
    var firstImageBox: some View {
        VStack(spacing: 8) {
            if let selectedImagePath = viewModel.newFirstImagePath {
                WorkViewImageBox(imageURL: selectedImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            } else {
                WorkViewImageBox(imageURL: viewModel.currentFirstImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            }
            firstImageBoxControls
        }
    }
    
    var secondImageBox: some View {
        VStack(spacing: 8) {
            if let selectedImagePath = viewModel.newSecondImagePath {
                WorkViewImageBox(imageURL: selectedImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            } else {
                WorkViewImageBox(imageURL: viewModel.currentSecondImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            }
            secondImageBoxControls
        }
    }
    
    // MARK: - Controls
    var bodyBoxControls: some View {
        HStack {
            if viewModel.canMoveBodyLeft {
                IconButton("arrow_left",
                           action: viewModel.moveBodyLeft)
            }
            changeBodyBoxStateButton
            if viewModel.canMoveBodyRight {
                IconButton("arrow_right",
                           action: viewModel.moveBodyRight)
            }
        }
    }
    
    var changeBodyBoxStateButton: some View {
        Button(action: viewModel.changeBodyBoxState) {
            Text(viewModel.changeBodyBoxStateTitle)
        }
    }
    
    var firstImageBoxControls: some View {
        HStack {
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK, let url = panel.url {
                    viewModel.newFirstImagePath = url
                }
            } label: {
                Text("Select")
            }
            if viewModel.newFirstImagePath != nil {
                Button {
                    viewModel.newFirstImagePath = nil
                } label: {
                    Text("Reset")
                }
            }
        }
    }
    
    var secondImageBoxControls: some View {
        HStack {
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK, let url = panel.url {
                    viewModel.newSecondImagePath = url
                }
            } label: {
                Text("Select")
            }
            if viewModel.newSecondImagePath != nil {
                Button {
                    viewModel.newSecondImagePath = nil
                } label: {
                    Text("Reset")
                }
            }
        }
    }
    
}



struct EditBookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            EditWorkView(editWork: .constant(EditWork(work: .preview, type: .cover)),
                         availableTags: ["Some", "tags", "data", "source"])
            
            EditWorkView(editWork: .constant(EditWork(type: .cover)),
                         availableTags: ["Some", "tags", "data", "source"])
            
        }
    }
}
