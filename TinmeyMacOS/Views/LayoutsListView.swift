//
//  LayoutsListView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import SwiftUI

struct LayoutsListView: View {
    @StateObject
    private var viewModel = LayoutsListViewModel()
    @State
    private var editLayout: EditLayoutType?
    @State
    private var showDeleteAlert = false
    @State
    private var layoutToDelete: Layout? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                grid
            }
            .padding()
        }
        .dimmedLoading(viewModel.isLoading)
        .sheet(item: $editLayout) {
            viewModel.loadAllLayouts()
        } content: { editLayout in
            switch editLayout {
            case .edit(let layout):
                EditLayoutView(layout: layout)
            case .new:
                EditLayoutView(layout: nil)
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
        .alert("Delete layout?",
               isPresented: $showDeleteAlert,
               presenting: layoutToDelete) { layoutToDelete in
            Button("Delete", role: .destructive, action: {
                viewModel.delete(layout: layoutToDelete)
            })
        }
    }
    
    private var grid: some View {
        LazyVGrid(columns: gridColumns, alignment: .center, spacing: 32) {
            layouts
        }
    }
    
    private var gridColumns: [GridItem] {
        let item = GridItem(.fixed(300), spacing: 32)
        return Array(repeating: item, count: 3)
    }
    
    private var layouts: some View {
        ForEach(viewModel.layouts, id: \.self) { layout in
            let layoutIndex = viewModel.layouts.firstIndex(of: layout)
            let isFirst = layoutIndex == 0
            let isLast = layoutIndex == viewModel.layouts.count - 1
            ItemView(item: layout,
                     onMoveLeft: isFirst ? nil : moveLayoutLeft,
                     onMoveRight: isLast ? nil : moveLayoutRight,
                     onEdit: editLayout,
                     onDelete: deleteLayout)
            .onDrag {
                viewModel.draggingLayout = layout
                return NSItemProvider(object: layout.id.uuidString as NSString)
            }
            .onDrop(of: [.text], delegate: LayoutDropDelegate(layout: layout, viewModel: viewModel))
        }
    }
    
    @ViewBuilder
    private func toolbars() -> some View {
        Button("Add new") {
            editLayout = .new
        }
        Button("Reload") {
            viewModel.loadAllLayouts()
        }
    }
    
    private func moveLayoutLeft(_ layout: Layout) {
        viewModel.moveLayoutLeft(layout)
    }
    
    private func moveLayoutRight(_ layout: Layout) {
        viewModel.moveLayoutRight(layout)
    }
    
    private func editLayout(_ layout: Layout) {
        editLayout = .edit(layout)
    }
    
    private func deleteLayout(_ layout: Layout) {
        layoutToDelete = layout
        showDeleteAlert.toggle()
    }
}

extension LayoutsListView {
    enum EditLayoutType: Hashable {
        case new
        case edit(Layout)
        
    }
}

extension LayoutsListView.EditLayoutType: Identifiable {
    var id: Self {
        self
    }
}

struct LayoutsListView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutsListView()
            .frame(width: 1200, height: 2000)
    }
}

