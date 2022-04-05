//
//  EditBookCoverView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import Foundation
import SwiftUI
import Combine

struct ErrorDescription: Identifiable {
    var id: String { text }
    let text: String
}

class EditWorksViewModel: ObservableObject {
    let id: Work.ID?
    @Published var work: Work.Create
    let availableTags: [String]
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    @Published var needImageSwap = false
    
    var title: String {
        if id != nil {
            return "Edit Work \"\(work.title)\""
        } else {
            return "Create new work"
        }
    }
    
    private let worksService = WorksAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    init(work: Work? = nil, availableTags: [String]) {
        if let work = work {
            self.id = work.id
            self.work = Work.Create(work)
        } else {
            self.id = nil
            self.work = Work.Create()
        }
        self.availableTags = availableTags
    }
    
    private let lock = NSRecursiveLock()
    
    func save(completion: @escaping () -> ()) {
        if let id = id {
            update(workID: id, to: work, completionHandler: completion)
        } else {
            create(newWork: work, completionHandler: completion)
        }
    }
    
    func create(newWork: Work.Create, completionHandler: @escaping () -> ()) {
        // TODO: Implement
        isLoading = true
        worksService.create(newWork: newWork)
            .flatMap { [weak self] work -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Just(())
                        .ignoreOutput()
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.addNewImages(to: work)
            }
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                    completionHandler()
                case .failure(let error):
                    print("Create Error:", error)
                    self?.isLoading = false
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            } receiveValue: { work in

            }
            .store(in: &subscriptions)
    }
    
    func update(workID: UUID, to newWork: Work.Create, completionHandler: @escaping () -> ()) {
        // TODO: Implement
        isLoading = true
        worksService.update(workID: workID, to: newWork)
            .flatMap { [worksService] work -> AnyPublisher<Void, Error> in
                let tasks = zip(
                    work.images,
                    newWork.images
                ).compactMap { (image, newImage) -> AnyPublisher<Void, Error>? in
                    switch newImage {
                    case .local(let url):
                        return worksService.addImage(from: url, to: image.id)
                    case .remote:
                        return nil
                    }
                }
                return Publishers.MergeMany(tasks).eraseToAnyPublisher()
            }
        
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                    completionHandler()
                case .failure(let error):
                    self?.isLoading = false
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            } receiveValue: {

            }
            .store(in: &subscriptions)
    }
    
    func moveImageBackward(item: Work.Image.Create) -> (() -> ())? {
        guard canMoveImageBackward(item: item) else { return nil }
        return { [weak self] in
            guard let self = self, let currentIndex = self.work.images.firstIndex(of: item) else { return }
            self.work.images.move(item, to: currentIndex - 1)
        }
    }
    
    func moveImageForward(item: Work.Image.Create) -> (() -> ())? {
        guard canMoveImageForward(item: item) else { return nil }
        return { [weak self] in
            guard let self = self, let currentIndex = self.work.images.firstIndex(of: item) else { return }
            self.work.images.move(item, to: currentIndex + 1)
        }
    }
    
    private func addNewImages(to work: Work) -> AnyPublisher<Void, Error> {
        let tasks = zip(
            work.images.map(\.id),
            self.work.images
        ).compactMap { (id, image) -> AnyPublisher<Void, Error>? in
            guard case let .local(url) = image else { return nil }
            return worksService.addImage(from: url, to: id)
        }
        return Publishers.MergeMany(tasks).eraseToAnyPublisher()
    }
    
    private func canMoveImageBackward(item: Work.Image.Create) -> Bool {
        let first = work.images.first
        return item != first
    }
    
    private func canMoveImageForward(item: Work.Image.Create) -> Bool {
        let last = work.images.last
        return item != last
    }
}
