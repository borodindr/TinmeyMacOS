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
    let work: Work?
    let workType: Work.WorkType
    @Published var newFirstImagePath: URL? = nil
    var currentFirstImagePath: URL? {
        work?.firstImageURL
    }
    @Published var newSecondImagePath: URL? = nil
    var currentSecondImagePath: URL? {
        work?.secondImageURL
    }
    @Published var titleText: String
    @Published var descriptionText: String
    @Published var tags: [String]
    let availableTags: [String]
    @Published var seeMoreLink: String
    @Binding var isPresented: Bool
    @Binding var workToEdit: Work?
    @Published private(set) var isLoading = false
    @Published var error: ErrorDescription? = nil
    @Published var workLayout: Work.LayoutType
    
    var title: String {
        if let work = work {
            return "Edit Work \"\(work.title)\""
        } else {
            return "Create new \(workType.rawValue)"
        }
    }
    
    var canMoveBodyLeft: Bool {
        switch workLayout {
        case .middleBody, .rightBody, .rightLargeBody:
            return true
        case .leftBody, .leftLargeBody:
            return false
        }
    }
    
    var canMoveBodyRight: Bool {
        switch workLayout {
        case .leftBody, .middleBody, .leftLargeBody:
            return true
        case .rightBody, .rightLargeBody:
            return false
        }
    }
    
    var changeBodyBoxStateTitle: String {
        switch workLayout {
        case .leftBody, .middleBody, .rightBody:
            return "Expand"
        case .leftLargeBody, .rightLargeBody:
            return "Collapse"
        }
    }
    
    private let worksService: WorksAPIService
    private var subscriptions = Set<AnyCancellable>()
    
    init(workType: Work.WorkType, availableTags: [String], isPresented: Binding<Bool>) {
        self.work = nil
        self.workType = workType
        self.titleText = ""
        self.descriptionText = ""
        self.tags = []
        self.availableTags = availableTags
        self.seeMoreLink = ""
        self._isPresented = isPresented
        self._workToEdit = .constant(nil)
        self.workLayout = .leftBody
        self.worksService = WorksAPIService(workType: workType)
    }
    
    init(work: Work, workType: Work.WorkType, availableTags: [String], workToEdit: Binding<Work?>) {
        self.work = work
        self.workType = workType
        self.titleText = work.title
        self.descriptionText = work.description
        self.tags = work.tags
        self.availableTags = availableTags
        self.seeMoreLink = work.seeMoreLink?.absoluteString ?? ""
        self._isPresented = .constant(false)
        self._workToEdit = workToEdit
        self.workLayout = work.layout
        self.worksService = WorksAPIService(workType: workType)
    }
    
    func createOrUpdate() {
        let newWork = Work.Create(
            type: workType,
            title: titleText,
            description: descriptionText,
            layout: workLayout,
            seeMoreLink: URL(string: seeMoreLink),
            tags: tags
        )
        if let work = work {
            update(workID: work.id, to: newWork)
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
                    self?.isPresented = false
                    self?.workToEdit = nil
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
                    self?.isPresented = false
                    self?.workToEdit = nil
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
        guard let indexToDelete = tags.firstIndex(of: tagToDelete) else {
            return
        }
        tags.remove(at: indexToDelete)
    }
    
    func addTag(_ tagToAdd: String) {
        guard !tags.contains(tagToAdd) else { return }
        tags.append(tagToAdd)
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
        if let imagePath = newFirstImagePath {
            return worksService.addFirstImage(from: imagePath, to: work.id)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private func addNewSecondImageIfNeeded(to work: Work) -> AnyPublisher<Void, Error> {
        if let imagePath = newSecondImagePath {
            return worksService.addSecondImage(from: imagePath, to: work.id)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func moveBodyRight() {
        switch workLayout {
        case .leftBody:
            workLayout = .middleBody
        case .middleBody:
            workLayout = .rightBody
        case .leftLargeBody:
            workLayout = .rightLargeBody
        case .rightBody, .rightLargeBody:
            break
        }
    }
    
    func moveBodyLeft() {
        switch workLayout {
        case .middleBody:
            workLayout = .leftBody
        case .rightBody:
            workLayout = .middleBody
        case .rightLargeBody:
            workLayout = .leftLargeBody
        case .leftBody, .leftLargeBody:
            break
        }
    }
    
    func changeBodyBoxState() {
        switch workLayout {
        case .leftBody:
            workLayout = .leftLargeBody
        case .middleBody, .rightBody:
            workLayout = .rightLargeBody
        case .leftLargeBody:
            workLayout = .leftBody
        case .rightLargeBody:
            workLayout = .middleBody
        }
    }
    
}
