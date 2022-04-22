//
//  LayoutsListViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import SwiftUI
import Combine

class LayoutsListViewModel: ObservableObject {
    @Published private(set) var layouts = [Layout]()
    @Published var selectedlLayout: Layout? = nil
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    @Published var draggingLayout: Layout?
    
    private let service: LayoutsProviderService
    var loadingDebounceTimer: Timer? = nil
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: LayoutsProviderService = LayoutsAPIService()) {
        self.service = service
        loadAllLayouts()
    }
    
    func loadAllLayouts() {
        startLoading()
        service.allLayouts()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                case .failure(let error):
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { [weak self] layouts in
                self?.layouts = layouts
            })
            .store(in: &subscriptions)
    }
    
    func delete(layout: Layout) {
        startLoading()
        service.delete(layoutID: layout.id)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                    self?.loadAllLayouts()
                case .failure(let error):
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &subscriptions)
    }
    
    func dragLayout(insteadOf layout: Layout) {
        guard let draggingLayout = draggingLayout,
              let fromIndex = layouts.firstIndex(of: draggingLayout),
              let toIndex = layouts.firstIndex(of: layout) else { return }
        let indexSet = IndexSet(integer: fromIndex)
        let toOffset = toIndex > fromIndex ? toIndex + 1 : toIndex
        layouts.move(fromOffsets: indexSet, toOffset: toOffset)
    }
    
    func applyMove(for layout: Layout) {
        guard let newIndex = layouts.firstIndex(of: layout) else { return }
        startLoading()
        service.move(layoutID: layout.id, newIndex: newIndex)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                    self?.loadAllLayouts()
                case .failure(let error):
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &subscriptions)
    }
    
    func moveLayoutLeft(_ layout: Layout) {
        guard let currentIndex = layouts.firstIndex(of: layout) else { return }
        let newIndex = currentIndex - 1
        layouts.move(layout, to: newIndex)
        applyMove(for: layout)
    }
    
    func moveLayoutRight(_ layout: Layout) {
        guard let currentIndex = layouts.firstIndex(of: layout) else { return }
        let newIndex = currentIndex + 1
        layouts.move(layout, to: newIndex)
        applyMove(for: layout)
    }
}

extension LayoutsListViewModel: LoadableViewModel {
    func onNew(loadingState: Bool) {
        isLoading = loadingState
    }
}

struct LayoutDropDelegate: DropDelegate {
    let layout: Layout
    let viewModel: LayoutsListViewModel

    func dropEntered(info: DropInfo) {
        guard layout != viewModel.draggingLayout else { return }
        withAnimation {
            viewModel.dragLayout(insteadOf: layout)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        viewModel.applyMove(for: layout)
        return true
    }
}

