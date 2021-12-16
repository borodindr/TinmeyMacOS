//
//  WorksListView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 04.10.2021.
//

import SwiftUI

struct WorksListView: View {
    @ObservedObject private var viewModel: WorksListViewModel
    
    @State private var editWork: EditWork?
    
    init(workType: Work.WorkType) {
        self.viewModel = WorksListViewModel(workType: workType)
    }
    
    // for preview
    fileprivate init(viewModel: WorksListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading && viewModel.works.isEmpty {
                Spacer()
                ProgressIndicator(size: .regular)
                Spacer()
            } else {
                list
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(item: $editWork, onDismiss: {
            viewModel.loadAllWorks()
        }, content: { _ in
            EditWorkView(editWork: $editWork,
                         availableTags: viewModel.availableTags)
        })
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.text),
                dismissButton: .default(Text("Close"))
            )
        }
        .onAppear(perform: {
            viewModel.loadAllWorks()
        })
    }
    
    private var list: some View {
        List {
            if AuthAPIService.isAuthorized {
                Button("Add new") {
                    editWork = EditWork(type: viewModel.workType)
                }
            }
            ForEach(viewModel.works, id: \.self) { work in
                let workIndex = viewModel.works.firstIndex(of: work)
                let isFirst = workIndex == 0
                let isLast = workIndex == viewModel.works.count - 1
                WorkView(work: work,
                         onMoveUp: isFirst ? nil : moveWorkUp,
                         onMoveDown: isLast ? nil : moveWorkDown,
                         onEdit: editWork,
                         onDelete: deleteWork)
            }
        }
        .listStyle(SidebarListStyle())
    }
    
    private func moveWorkUp(_ work: Work) {
        viewModel.moveWorkUp(work)
    }
    
    private func moveWorkDown(_ work: Work) {
        viewModel.moveWorkDown(work)
    }
    
    private func editWork(_ work: Work) {
        editWork = EditWork(work: work, type: viewModel.workType)
    }
    
    private func deleteWork(_ work: Work) {
        viewModel.delete(work: work)
    }
}

struct WorksListView_Previews: PreviewProvider {
    static var previews: some View {
        WorksListView(
            viewModel: WorksListViewModel(
                service: WorksPreviewService(workType: .cover)
            )
        )
            .frame(width: 1200, height: 2000)
    }
}
