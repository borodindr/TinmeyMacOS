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
    @Published var selectedWork: Work? = nil
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    
    var workType: Work.WorkType {
        service.workType
    }
    private let service: WorksProviderService
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: WorksProviderService) {
        self.service = service
    }
    
    init(workType: Work.WorkType) {
        self.service = WorksAPIService(workType: workType)
    }
    
    func loadAllWorks() {
        isLoading = true
        service.allWorks()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { [weak self] works in
                self?.works = works
            })
            .store(in: &subscriptions)
    }
    
    func delete(work: Work) {
        isLoading = true
        service.delete(workID: work.id)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                    self?.loadAllWorks()
                case .failure(let error):
                    self?.isLoading = false
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
    
    private func moveWork(_ work: Work, direction: Work.ReorderDirection) {
        service.reorder(workID: work.id, direction: direction)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                    self?.loadAllWorks()
                case .failure(let error):
                    self?.isLoading = false
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &subscriptions)
    }
}
