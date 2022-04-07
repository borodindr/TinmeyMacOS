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
    
    func moveWorkUp(_ work: Work) {
        moveWork(work, direction: .forward)
    }
    
    func moveWorkDown(_ work: Work) {
        moveWork(work, direction: .backward)
    }
    
    private func moveWork(_ work: Work, direction: ReorderDirection) {
        guard let currentIndex = works.firstIndex(of: work) else { return }
        startLoading()
        let newIndex: Int
        switch direction {
        case .forward:
            newIndex = currentIndex - 1
        case .backward:
            newIndex = currentIndex + 1
        }
        works.move(work, to: newIndex)
        service.reorder(workID: work.id, direction: direction)
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
    
}

extension WorksListViewModel: LoadableViewModel {
    func onNew(loadingState: Bool) {
        isLoading = loadingState
    }
}
