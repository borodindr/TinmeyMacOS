////
////  BookCoversListView.swift
////  TinmeyMacOS
////
////  Created by Dmitry Borodin on 19.08.2021.
////
//
//import SwiftUI
//
//struct WorksListViewOld: View {
//    @ObservedObject private var viewModel: WorksListViewModel
//
//    @State private var editWorkPresented = false
//    @State private var searchText = ""
//
//    init(workType: WorkType) {
//        self.viewModel = WorksListViewModel(workType: workType)
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                toolbar
//                searchField
//                if viewModel.isLoading && viewModel.works.isEmpty {
//                    Spacer()
//                    ProgressIndicator(size: .regular)
//                    Spacer()
//                } else {
//                    list
//                }
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//        .sheet(isPresented: $editWorkPresented, onDismiss: {
//            viewModel.loadAllWorks()
//        }, content: {
//            EditWorkView(workType: viewModel.workType, isPresented: $editWorkPresented)
//        })
//        .onAppear(perform: {
//            viewModel.loadAllWorks()
//        })
//    }
//
//    private var toolbarLoader: some View {
//        HStack(spacing: 0) {
//            ProgressIndicator(size: .mini)
//                .frame(width: 20, height: 20)
//            Text("Loading...")
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//    }
//
//    private var toolbar: some View {
//        HStack {
//            if viewModel.isLoading && !viewModel.works.isEmpty {
//                toolbarLoader
//            }
//            Spacer()
//            Button(action: {
//
//            }, label: {
//                Image("trash")
//                    .font(.caption)
//                    .foregroundColor(viewModel.selectedWork == nil ? .secondary : .primary)
//            })
//            .disabled(viewModel.selectedWork == nil)
//            Button(action: {
//                editWorkPresented = true
//            }, label: {
//                Image("plus")
//                    .font(.caption)
//                    .foregroundColor(.white)
//            })
//        }
//        .padding(.horizontal)
//        .padding(.bottom, 8)
//    }
//    
//    private var searchField: some View {
//        HStack {
//            Image("magnifyingglass")
//                .foregroundColor(.gray)
//            TextField("Search", text: $searchText)
//                .textFieldStyle(PlainTextFieldStyle())
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal)
//        .background(Color.primary.opacity(0.15))
//        .cornerRadius(10)
//        .padding()
//    }
//
//    private var list: some View {
//        List(selection: $viewModel.selectedWork) {
//            ForEach(viewModel.works, id: \.self) { work in
//                NavigationLink(
//                    destination: WorkView(workID: work.id),
//                    label: {
//                        WorkPreview(workPreview: work)
//                    })
//            }
//        }
//        .listStyle(SidebarListStyle())
//        .frame(width: 250)
//    }
//}
//
//struct BookCoversListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorksListView(workType: .cover)
//    }
//}
