//
//  BookCoversListViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI
import Combine

class WorksListViewModel: ObservableObject {
    @Published private(set) var works = [Work]()
    var availableTags = [String]()
    @Published var selectedWork: Work? = nil
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    @Published var draggingWork: Work?
    
    private let service: WorksProviderService
    private let tagsService = TagsAPIService()
    var loadingDebounceTimer: Timer? = nil
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: WorksProviderService = WorksAPIService()) {
        self.service = service
        loadAllWorks()
    }
    
    func loadAllWorks() {
        startLoading()
        service.allWorks()
            .flatMap { [tagsService] works in
                tagsService.getAll()
                    .map { (works: works, tags: $0)}
            }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                case .failure(let error):
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { [weak self] works, tags in
                self?.works = works
                self?.availableTags = tags
            })
            .store(in: &subscriptions)
    }
    
    func delete(work: Work) {
        startLoading()
        service.delete(workID: work.id)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                    self?.loadAllWorks()
                case .failure(let error):
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &subscriptions)
    }
    
    func dragWork(insteadOf work: Work) {
        guard let draggingWork = draggingWork,
              let fromIndex = works.firstIndex(of: draggingWork),
              let toIndex = works.firstIndex(of: work) else { return }
        let indexSet = IndexSet(integer: fromIndex)
        let toOffset = toIndex > fromIndex ? toIndex + 1 : toIndex
        works.move(fromOffsets: indexSet, toOffset: toOffset)
    }
    
    func applyMove(for work: Work) {
        guard let newIndex = works.firstIndex(of: work) else { return }
        startLoading()
        service.move(workID: work.id, newIndex: newIndex)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                    self?.loadAllWorks()
                case .failure(let error):
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &subscriptions)
    }
    
    func moveWorkLeft(_ work: Work) {
        guard let currentIndex = works.firstIndex(of: work) else { return }
        let newIndex = currentIndex - 1
        works.move(work, to: newIndex)
        applyMove(for: work)
    }
    
    func moveWorkRight(_ work: Work) {
        guard let currentIndex = works.firstIndex(of: work) else { return }
        let newIndex = currentIndex + 1
        works.move(work, to: newIndex)
        applyMove(for: work)
    }
}

extension WorksListViewModel: LoadableViewModel {
    func onNew(loadingState: Bool) {
        isLoading = loadingState
    }
}

struct WorkDropDelegate: DropDelegate {
    let work: Work
    let viewModel: WorksListViewModel

    func dropEntered(info: DropInfo) {
        guard work != viewModel.draggingWork else { return }
        withAnimation {
            viewModel.dragWork(insteadOf: work)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        viewModel.applyMove(for: work)
        return true
    }
}
