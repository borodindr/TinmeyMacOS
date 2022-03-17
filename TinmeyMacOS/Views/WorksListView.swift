//
//  WorksListView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 04.10.2021.
//

import SwiftUI

struct WorksListView: View {
    @ObservedObject private var viewModel: WorksListViewModel
    @State private var editWork: EditWorkType?
    
    init() {
        self.viewModel = WorksListViewModel()
    }
    
    // for preview
    fileprivate init(viewModel: WorksListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading && viewModel.works.isEmpty {
                    Spacer()
                    ProgressIndicator(size: .regular)
                    Spacer()
                } else {
                    grid
                }
            }
            .padding()
        }
        .sheet(item: $editWork, onDismiss: {
            viewModel.loadAllWorks()
        }, content: { editWork in
            switch editWork {
            case .edit(let work):
                EditWorkView(work: work, availableTags: viewModel.availableTags)
            case .new:
                EditWorkView(work: nil, availableTags: viewModel.availableTags)
            }
        })
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.text),
                dismissButton: .default(Text("Close"))
            )
        }
        .toolbar {
            Button("Add new") {
                editWork = .new
            }
            Button("Reload") {
                viewModel.loadAllWorks()
            }
        }
    }
    
    private var grid: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.fixed(300), spacing: 32),
                count: 3
            ),
            alignment: .center,
            spacing: 32) {
                ForEach(viewModel.works, id: \.self) { work in
                    let workIndex = viewModel.works.firstIndex(of: work)
                    let isFirst = workIndex == 0
                    let isLast = workIndex == viewModel.works.count - 1
                    WorkView(work: work,
                             onMoveLeft: isFirst ? nil : moveWorkUp,
                             onMoveRight: isLast ? nil : moveWorkDown,
                             onEdit: editWork,
                             onDelete: deleteWork)
                }
            }
    }
    
    private func moveWorkUp(_ work: Work) {
        viewModel.moveWorkUp(work)
    }
    
    private func moveWorkDown(_ work: Work) {
        viewModel.moveWorkDown(work)
    }
    
    private func editWork(_ work: Work) {
        editWork = .edit(work)
    }
    
    private func deleteWork(_ work: Work) {
        viewModel.delete(work: work)
    }
}

extension WorksListView {
    enum EditWorkType: Hashable {
        case new
        case edit(Work)
        
    }
}

extension WorksListView.EditWorkType: Identifiable {
    var id: Self {
        self
    }
}

struct WorksListView_Previews: PreviewProvider {
    static var previews: some View {
        WorksListView(
            viewModel: WorksListViewModel(
                service: WorksPreviewService()
            )
        )
            .frame(width: 1200, height: 2000)
    }
}
