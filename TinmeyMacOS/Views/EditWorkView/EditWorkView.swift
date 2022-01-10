//
//  EditBookCoverView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI

struct EditWorkView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: EditWorksViewModel
    init(work: Work?, type: Work.WorkType, availableTags: [String]) {
        self.viewModel = EditWorksViewModel(work: work, type: type, availableTags: availableTags)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 8) {
                    // Title
                    Text(viewModel.title)
                        .font(.title)
                        .padding(.top, 16)
                    
                    boxes
                    
                    HStack {
                        if viewModel.work.canRemoveRow {
                            Button(action: removeRow) {
                                Text("-")
                            }
                        }

                        Button {
                            viewModel.work.addRow()
                        } label: {
                            Text("+")
                        }
                        
                    }
                    
                    // See more link
                    TextField("See work link", text: $viewModel.work.seeMoreLink)
                    
                    // Tags
                    HStack {
                        TagInputView(tags: $viewModel.work.tags)
                        TagSelectView(selectedTags: $viewModel.work.tags,
                                      availableTags: viewModel.availableTags)
                        Spacer()
                    }
                    
                    // Controls
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Dismiss")
                        })
                        Spacer()
                        Button(action: {
                            viewModel.createOrUpdate {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }, label: {
                            Text("Save")
                        })
                    }
                }
                .padding()
            }
            
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
        VStack(spacing: 0) {
            ForEach($viewModel.work.twoDArray) { $row in
                HStack(spacing: 0) {
                    ForEach($row) { $item in
                        let work = viewModel.work
                        let canMoveBackward = work.canMoveBackward(item: item)
                        let canMoveForward = work.canMoveForward(item: item)
                        EditWorkItemView(
                            item: $item,
                            work: $viewModel.work,
                            onMoveBackward: canMoveBackward ? moveItemBackward : nil,
                            onMoveForward: canMoveForward ? moveItemForward : nil
                        )
                            .padding(.bottom, 8)
                    }
                }
            }
        }
    }
    
    
    private var canRemoveRow: Bool {
        viewModel.work.canRemoveRow
    }
    
    private func removeRow() {
        viewModel.work.removeRow()
    }
    
    private func moveItemBackward(item: Work.Item.Create) {
        viewModel.work.moveBackward(item: item)
    }
    
    private func moveItemForward(item: Work.Item.Create) {
        viewModel.work.moveForward(item: item)
    }
}



struct EditBookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditWorkView(work: .preview,
                         type: .cover,
                         availableTags: ["Some", "tags", "data", "source"])
            
            EditWorkView(work: nil,
                         type: .cover,
                         availableTags: ["Some", "tags", "data", "source"])
            
        }
    }
}
