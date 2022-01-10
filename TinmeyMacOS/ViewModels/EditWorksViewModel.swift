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
    var workType: Work.WorkType {
        worksService.workType
    }
    @Published var work: Work.Create
    let availableTags: [String]
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    @Published var needImageSwap = false
    
    var title: String {
        if id != nil {
            return "Edit Work \"\(work.title)\""
        } else {
            return "Create new \(workType.rawValue)"
        }
    }
    
    private let worksService: WorksAPIService
    private var subscriptions = Set<AnyCancellable>()
    
    init(work: Work? = nil, type: Work.WorkType, availableTags: [String]) {
        if let work = work {
            self.id = work.id
            self.work = Work.Create(work)
        } else {
            self.id = nil
            self.work = Work.Create()
        }
        self.availableTags = availableTags
        self.worksService = WorksAPIService(workType: type)
        loadImages()
    }
    
    private let lock = NSRecursiveLock()
    
    func loadImages() {
        for image in work.images {
            guard let url = image.currentImageURL else { continue }
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .map { NSImage.init(data: $0) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] loadedImage in
                    self?.lock.lock()
                    self?.work.images[image.id]?.currentImage = loadedImage
                    self?.lock.unlock()
                })
                .store(in: &subscriptions)
        }
    }
    
    func createOrUpdate(completion: @escaping () -> ()) {
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
                    if let url = newImage.newImageURL {
                        return worksService.addImage(from: url, to: image.id)
                    } else if image.path != nil && newImage.currentImageURL == nil {
                        return worksService.deleteImage(imageID: image.id)
                    } else {
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
    
    private func addNewImages(to work: Work) -> AnyPublisher<Void, Error> {
        let tasks = zip(
            work.images.map(\.id),
            self.work.images.map(\.newImageURL)
        ).compactMap { (id, url) -> AnyPublisher<Void, Error>? in
            guard let url = url else { return nil }
            return worksService.addImage(from: url, to: id)
        }
        return Publishers.MergeMany(tasks).eraseToAnyPublisher()
    }
    
}
