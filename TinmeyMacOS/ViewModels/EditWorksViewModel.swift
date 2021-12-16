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
    @Binding var editWork: EditWork?
    @Binding var newFirstImagePath: URL?
    var currentFirstImagePath: URL? {
        if needImageSwap {
            return editWork?.currentSecondImagePath
        } else {
            return editWork?.currentFirstImagePath
        }
    }
    @Binding var newSecondImagePath: URL?
    var currentSecondImagePath: URL? {
        if needImageSwap {
            return editWork?.currentFirstImagePath
        } else {
            return editWork?.currentSecondImagePath
        }
    }
    @Binding var titleText: String
    @Binding var descriptionText: String
    @Binding var tags: [String]
    let availableTags: [String]
    @Binding var seeMoreLink: String
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    @Published var needImageSwap = false
    
    var title: String {
        guard let editWork = editWork else {
            return ""
        }
        if editWork.id != nil {
            return "Edit Work \"\(editWork.title)\""
        } else {
            return "Create new \(editWork.type.rawValue)"
        }
    }
    
    var canMoveBodyLeft: Bool {
        guard let editWork = editWork else {
            return false
        }
        switch editWork.layout {
        case .middleBody, .rightBody, .rightLargeBody:
            return true
        case .leftBody, .leftLargeBody:
            return false
        }
    }
    
    var canMoveBodyRight: Bool {
        guard let editWork = editWork else {
            return false
        }
        switch editWork.layout {
        case .leftBody, .middleBody, .leftLargeBody:
            return true
        case .rightBody, .rightLargeBody:
            return false
        }
    }
    
    var canMoveFirstImageLeft: Bool {
        guard let editWork = editWork else {
            return false
        }
        switch editWork.layout {
        case .leftBody, .leftLargeBody:
            return true
        case .middleBody, .rightBody, .rightLargeBody:
            return false
        }
    }
    
    var canMoveFirstImageRight: Bool {
        guard let editWork = editWork else {
            return false
        }
        switch editWork.layout {
        case .leftBody, .middleBody, .rightBody, .rightLargeBody:
            return true
        case .leftLargeBody:
            return false
        }
    }
    
    var canMoveSecondImageLeft: Bool {
        guard let editWork = editWork else {
            return false
        }
        switch editWork.layout {
        case .leftBody, .middleBody, .rightBody:
            return true
        case .leftLargeBody, .rightLargeBody:
            return false
        }
    }
    
    var canMoveSecondImageRight: Bool {
        guard let editWork = editWork else {
            return false
        }
        switch editWork.layout {
        case .rightBody:
            return true
        case .leftBody, .middleBody, .leftLargeBody, .rightLargeBody:
            return false
        }
    }
    
    var changeBodyBoxStateTitle: String {
        guard let editWork = editWork else {
            return ""
        }
        switch editWork.layout {
        case .leftBody, .middleBody, .rightBody:
            return "Expand"
        case .leftLargeBody, .rightLargeBody:
            return "Collapse"
        }
    }
    
    private let worksService: WorksAPIService
    private var subscriptions = Set<AnyCancellable>()
    
    init(editWork: Binding<EditWork?>, availableTags: [String]) {
        self._editWork = editWork
        self.availableTags = availableTags
        self.worksService = WorksAPIService(workType: editWork.wrappedValue?.type ?? .cover)
        
        _seeMoreLink = .init(get: {
            editWork.wrappedValue?.seeMoreLink ?? ""
        }, set: { newValue in
            editWork.wrappedValue?.seeMoreLink = newValue
        })
        _titleText = .init(get: {
            editWork.wrappedValue?.title ?? ""
        }, set: { newValue in
            editWork.wrappedValue?.title = newValue
        })
        _descriptionText = .init(get: {
            editWork.wrappedValue?.description ?? ""
        }, set: { newValue in
            editWork.wrappedValue?.description = newValue
        })
        _tags = .init(get: {
            editWork.wrappedValue?.tags ?? []
        }, set: { newValue in
            editWork.wrappedValue?.tags = newValue
        })
        _newFirstImagePath = .init(get: {
            editWork.wrappedValue?.newFirstImagePath
        }, set: { newValue in
            editWork.wrappedValue?.newFirstImagePath = newValue
        })
        _newSecondImagePath = .init(get: {
            editWork.wrappedValue?.newSecondImagePath
        }, set: { newValue in
            editWork.wrappedValue?.newSecondImagePath = newValue
        })
    }
    
    func createOrUpdate() {
        guard let editWork = editWork else {
            return
        }
        let newWork = Work.Create(
            type: editWork.type,
            title: editWork.title,
            description: editWork.description,
            layout: editWork.layout,
            seeMoreLink: URL(string: editWork.seeMoreLink),
            tags: editWork.tags
        )
        if let id = editWork.id {
            update(workID: id, to: newWork)
        } else {
            create(newWork: newWork)
        }
    }
    
    func create(newWork: Work.Create) {
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
                    self?.editWork = nil
                    self?.isLoading = false
                case .failure(let error):
                    print("Create Error:", error)
                    self?.isLoading = false
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            } receiveValue: { work in
                
            }
            .store(in: &subscriptions)
    }
    
    func update(workID: UUID, to newWork: Work.Create) {
        isLoading = true
        worksService.update(workID: workID, to: newWork)
            .flatMap { [weak self] work -> AnyPublisher<Work, Error> in
                guard let self = self else {
                    return Just(work)
                        .ignoreOutput()
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.swapOnServerIfNeeded(work: work)
            }
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
                    self?.editWork = nil
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            } receiveValue: { _ in
                
            }
            .store(in: &subscriptions)
    }
    
    func deleteTag(_ tagToDelete: String) {
        guard let indexToDelete = editWork?.tags.firstIndex(of: tagToDelete) else {
            return
        }
        editWork?.tags.remove(at: indexToDelete)
    }
    
    func addTag(_ tagToAdd: String) {
        guard !(editWork?.tags.contains(tagToAdd) ?? false) else { return }
        editWork?.tags.append(tagToAdd)
    }
    
    private func swapOnServerIfNeeded(work: Work) -> AnyPublisher<Work, Error> {
        let hasUnchangedImages = newFirstImagePath == nil || newSecondImagePath == nil
        guard needImageSwap, hasUnchangedImages else {
            return Just(work)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return worksService.swapImages(workID: work.id)
    }
    
    private func addNewImages(to work: Work) -> AnyPublisher<Void, Error> {
        Publishers
            .Merge(
                addNewFirstImageIfNeeded(to: work),
                addNewSecondImageIfNeeded(to: work)
            )
            .eraseToAnyPublisher()
    }
    
    private func addNewFirstImageIfNeeded(to work: Work) -> AnyPublisher<Void, Error> {
        if let imagePath = editWork?.newFirstImagePath {
            return worksService.addFirstImage(from: imagePath, to: work.id)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private func addNewSecondImageIfNeeded(to work: Work) -> AnyPublisher<Void, Error> {
        if let imagePath = editWork?.newSecondImagePath {
            return worksService.addSecondImage(from: imagePath, to: work.id)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private func swapImages() {
        needImageSwap.toggle()
        let newFirstImagePath = self.newSecondImagePath
        let newSecondImagePath = self.newFirstImagePath
        self.newFirstImagePath = newFirstImagePath
        self.newSecondImagePath = newSecondImagePath
    }
    
    func moveBodyRight() {
        switch editWork?.layout {
        case .leftBody:
            editWork?.layout = .middleBody
        case .middleBody:
            editWork?.layout = .rightBody
        case .leftLargeBody:
            editWork?.layout = .rightLargeBody
        case .rightBody, .rightLargeBody:
            break
        case .none:
            break
        }
    }
    
    func moveBodyLeft() {
        switch editWork?.layout {
        case .middleBody:
            editWork?.layout = .leftBody
        case .rightBody:
            editWork?.layout = .middleBody
        case .rightLargeBody:
            editWork?.layout = .leftLargeBody
        case .leftBody, .leftLargeBody:
            break
        case .none:
            break
        }
    }
    
    func moveFirstImageLeft() {
        switch editWork?.layout {
        case .leftBody:
            editWork?.layout = .middleBody
        case .leftLargeBody:
            editWork?.layout = .rightLargeBody
        case .middleBody, .rightBody, .rightLargeBody:
            break
        case .none:
            break
        }
    }
    
    func moveFirstImageRight() {
        switch editWork?.layout {
        case .leftBody:
            swapImages()
        case .middleBody:
            editWork?.layout = .leftBody
        case .rightBody:
            swapImages()
        case .rightLargeBody:
            editWork?.layout = .leftLargeBody
        case .leftLargeBody:
            break
        case .none:
            break
        }
    }
    
    func moveSecondImageLeft() {
        switch editWork?.layout {
        case .leftBody:
            swapImages()
        case .middleBody:
            editWork?.layout = .rightBody
        case .rightBody:
            swapImages()
        case .leftLargeBody, .rightLargeBody:
            break
        case .none:
            break
        }
    }
    
    func moveSecondImageRight() {
        switch editWork?.layout {
        case .rightBody:
            editWork?.layout = .middleBody
        case .leftBody, .middleBody, .leftLargeBody, .rightLargeBody:
            break
        case .none:
            break
        }
    }
    
    func changeBodyBoxState() {
        switch editWork?.layout {
        case .leftBody:
            editWork?.layout = .leftLargeBody
        case .middleBody, .rightBody:
            editWork?.layout = .rightLargeBody
        case .leftLargeBody:
            editWork?.layout = .leftBody
        case .rightLargeBody:
            editWork?.layout = .middleBody
        case .none:
            break
        }
    }
    
}
