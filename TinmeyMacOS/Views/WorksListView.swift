//
//  WorksListView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 04.10.2021.
//

import SwiftUI

struct WorksListView: View {
    @StateObject private var viewModel = WorksListViewModel()
    @State private var editWork: EditWorkType?
    @State
    private var showDeleteAlert = false
    @State
    private var workToDelete: Work? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                grid
            }
            .padding()
        }
        .dimmedLoading(viewModel.isLoading)
        .sheet(item: $editWork) {
            viewModel.loadAllWorks()
        } content: { editWork in
            switch editWork {
            case .edit(let work):
                EditWorkView(work: work, availableTags: viewModel.availableTags)
            case .new:
                EditWorkView(work: nil, availableTags: viewModel.availableTags)
            }
        }
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.text),
                dismissButton: .default(Text("Close"))
            )
        }
        .toolbar(content: toolbars)
        .alert("Delete work?",
               isPresented: $showDeleteAlert,
               presenting: workToDelete) { workToDelete in
            Button("Delete", role: .destructive, action: {
                viewModel.delete(work: workToDelete)
            })
        }
    }
    
    private var grid: some View {
        LazyVGrid(columns: gridColumns, alignment: .center, spacing: 32) {
            works
        }
    }
    
    private var gridColumns: [GridItem] {
        let item = GridItem(.fixed(300), spacing: 32)
        return Array(repeating: item, count: 3)
    }
    
    private var works: some View {
        ForEach(viewModel.works, id: \.self) { work in
            let workIndex = viewModel.works.firstIndex(of: work)
            let isFirst = workIndex == 0
            let isLast = workIndex == viewModel.works.count - 1
            ItemView(item: work,
                     onMoveLeft: isFirst ? nil : moveWorkLeft,
                     onMoveRight: isLast ? nil : moveWorkRight,
                     onEdit: editWork,
                     onDelete: deleteWork)
            .onDrag {
                viewModel.draggingWork = work
                return NSItemProvider(object: work.id.uuidString as NSString)
            }
            .onDrop(of: [.text], delegate: WorkDropDelegate(work: work, viewModel: viewModel))
        }
    }
    
    @ViewBuilder
    private func toolbars() -> some View {
        Button("Add new") {
            editWork = .new
        }
        Button("Reload") {
            viewModel.loadAllWorks()
        }
    }
    
    private func moveWorkLeft(_ work: Work) {
        viewModel.moveWorkLeft(work)
    }
    
    private func moveWorkRight(_ work: Work) {
        viewModel.moveWorkRight(work)
    }
    
    private func editWork(_ work: Work) {
        editWork = .edit(work)
    }
    
    private func deleteWork(_ work: Work) {
        workToDelete = work
        showDeleteAlert.toggle()
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
        WorksListView()
            .frame(width: 1200, height: 2000)
    }
}
