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
    init(work: Work?, availableTags: [String]) {
        self.viewModel = EditWorksViewModel(work: work, availableTags: availableTags)
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
                        EditWorkItemView(
                            item: $item,
                            work: $viewModel.work,
                            onMoveBackward: nil,
                            onMoveForward: nil
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
        
    }
    
    private func moveItemForward(item: Work.Item.Create) {
        
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
