//
//  EditLayoutsViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.04.2022.
//

import Foundation
import SwiftUI
import Combine

class EditLayoutsViewModel: ObservableObject {
    let id: Layout.ID?
    @Published var layout: Layout.Create
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    @Published var needImageSwap = false
    var loadingDebounceTimer: Timer?
    
    var title: String {
        if id != nil {
            return "Edit Layout \"\(layout.title)\""
        } else {
            return "Create new layout"
        }
    }
    
    private let layoutsService = LayoutsAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    init(layout: Layout? = nil) {
        if let layout = layout {
            self.id = layout.id
            self.layout = Layout.Create(layout)
        } else {
            self.id = nil
            self.layout = Layout.Create()
        }
    }
    
    func save(completion: @escaping () -> ()) {
        if let id = id {
            update(layoutID: id, to: layout, completionHandler: completion)
        } else {
            create(newLayout: layout, completionHandler: completion)
        }
    }
    
    func create(newLayout: Layout.Create, completionHandler: @escaping () -> ()) {
        // TODO: Implement
        startLoading()
        layoutsService.create(newLayout: newLayout)
            .flatMap { [weak self] layout -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Just(())
                        .ignoreOutput()
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.addNewImages(to: layout)
            }
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                    completionHandler()
                case .failure(let error):
                    print("Create Error:", error)
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            } receiveValue: { layout in

            }
            .store(in: &subscriptions)
    }
    
    func update(layoutID: UUID, to newLayout: Layout.Create, completionHandler: @escaping () -> ()) {
        // TODO: Implement
        startLoading()
        layoutsService.update(layoutID: layoutID, to: newLayout)
            .flatMap { [layoutsService] layout -> AnyPublisher<Void, Error> in
                let tasks = zip(
                    layout.images,
                    newLayout.images
                ).compactMap { (image, newImage) -> AnyPublisher<Void, Error>? in
                    switch newImage {
                    case .local(let url):
                        return layoutsService.addImage(from: url, to: image.id)
                    case .remote:
                        return nil
                    }
                }
                return Publishers.MergeMany(tasks).eraseToAnyPublisher()
            }
        
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopLoading()
                    completionHandler()
                case .failure(let error):
                    self?.stopLoading()
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            } receiveValue: {

            }
            .store(in: &subscriptions)
    }
    
    func moveImageBackward(item: Layout.Image.Create) -> (() -> ())? {
        guard canMoveImageBackward(item: item) else { return nil }
        return { [weak self] in
            guard let self = self, let currentIndex = self.layout.images.firstIndex(of: item) else { return }
            self.layout.images.move(item, to: currentIndex - 1)
        }
    }
    
    func moveImageForward(item: Layout.Image.Create) -> (() -> ())? {
        guard canMoveImageForward(item: item) else { return nil }
        return { [weak self] in
            guard let self = self, let currentIndex = self.layout.images.firstIndex(of: item) else { return }
            self.layout.images.move(item, to: currentIndex + 1)
        }
    }
    
    private func addNewImages(to layout: Layout) -> AnyPublisher<Void, Error> {
        let tasks = zip(
            layout.images.map(\.id),
            self.layout.images
        ).compactMap { (id, image) -> AnyPublisher<Void, Error>? in
            guard case let .local(url) = image else { return nil }
            return layoutsService.addImage(from: url, to: id)
        }
        return Publishers.MergeMany(tasks).eraseToAnyPublisher()
    }
    
    private func canMoveImageBackward(item: Layout.Image.Create) -> Bool {
        let first = layout.images.first
        return item != first
    }
    
    private func canMoveImageForward(item: Layout.Image.Create) -> Bool {
        let last = layout.images.last
        return item != last
    }
}

extension EditLayoutsViewModel: LoadableViewModel {
    func onNew(loadingState: Bool) {
        isLoading = loadingState
    }
}

