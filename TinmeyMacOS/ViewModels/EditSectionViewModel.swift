//
//  EditSectionViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import SwiftUI
import Combine
import TinmeyCore
import AppKit

final class EditSectionViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var alert: AlertType? = nil
    @Published var title = ""
    @Published var subtitle = ""
    @Published var previewSubtitle = ""
    @Published var newFirstImageURL: URL?
    @Published var newSecondImageURL: URL?
    
    @Published var firstImage: NSImage?
    @Published var secondImage: NSImage?
    
    let sectionType: SectionAPIModel.SectionType
    private let service = SectionsAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    init(sectionType: SectionAPIModel.SectionType) {
        self.sectionType = sectionType
    }
    
    func loadSection() {
        isLoading = true
        alert = nil
        loadImages()
        service.getSection(ofType: sectionType)
            
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] section in
                self?.title = section.preview.title
                self?.subtitle = section.subtitle
                self?.previewSubtitle = section.preview.subtitle
                self?.newFirstImageURL = nil
                self?.newSecondImageURL = nil
            }
            .store(in: &subscriptions)
    }
    
    func saveSection() {
        isLoading = true
        let newSection = SectionAPIModel(
            type: sectionType,
            subtitle: subtitle,
            preview: SectionAPIModel.Preview(
                title: title,
                subtitle: previewSubtitle
            )
        )
        service.updateSection(newSection)
            .flatMap { [weak self] section -> AnyPublisher<SectionAPIModel, Error> in
                guard let self = self else {
                    return Just(section)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.addNewImages()
                    .map { section }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.alert = .success(message: "Successfully saved section")
                case .failure(let error):
                    self?.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] section in
                self?.title = section.preview.title
                self?.subtitle = section.subtitle
                self?.previewSubtitle = section.preview.subtitle
                self?.newFirstImageURL = nil
                self?.newSecondImageURL = nil
            }
            .store(in: &subscriptions)
    }
    
    private func loadImages() {
        loadFirstImage()
        loadSecondImage()
    }
    
    private func loadFirstImage() {
        let url = APIURLBuilder()
            .path("sections")
            .path("covers")
            .path("firstImage")
            .buildURL()
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map { NSImage.init(data: $0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.firstImage, on: self)
            .store(in: &subscriptions)
    }
    
    private func loadSecondImage() {
        let url = APIURLBuilder()
            .path("sections")
            .path("covers")
            .path("secondImage")
            .buildURL()
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map { NSImage.init(data: $0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.secondImage, on: self)
            .store(in: &subscriptions)
    }
    
    private func addNewImages() -> AnyPublisher<Void, Error> {
        Publishers
            .Merge(
                addNewFirstImageIfNeeded(),
                addNewSecondImageIfNeeded()
            )
            .eraseToAnyPublisher()
    }
    
    private func addNewFirstImageIfNeeded() -> AnyPublisher<Void, Error> {
        if let imagePath = newFirstImageURL {
            return service.addFirstImage(from: imagePath, for: sectionType)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private func addNewSecondImageIfNeeded() -> AnyPublisher<Void, Error> {
        if let imagePath = newSecondImageURL {
            return service.addSecondImage(from: imagePath, for: sectionType)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
