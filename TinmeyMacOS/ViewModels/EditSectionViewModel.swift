//
//  EditSectionViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import SwiftUI
import Combine
import TinmeyCore

final class EditSectionViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var alert: AlertType? = nil
    @Published var title = ""
    @Published var subtitle = ""
    @Published var newFirstImagePath: URL?
//    @Published private(set) var currentFirstImagePath: URL? = nil
    @Published var newSecondImagePath: URL?
//    @Published private(set) var currentSecondImagePath: URL? = nil
    
    let sectionType: SectionAPIModel.SectionType
    var firstImageURL: URL? {
        let urlString = baseImageURLString + "/firstImage"
        return URL(string: urlString)
    }
    
    var secondImageURL: URL? {
        let urlString = baseImageURLString + "/secondImage"
        return URL(string: urlString)
    }
    
    private var baseImageURLString: String {
        "http://127.0.0.1:8080/api/sections/" + sectionType.rawValue
    }
    private let service = SectionsAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    init(sectionType: SectionAPIModel.SectionType) {
        self.sectionType = sectionType
        self.newFirstImagePath = firstImageURL
        self.newSecondImagePath = secondImageURL
        loadSection()
    }
    
    func loadSection() {
        isLoading = true
        alert = nil
//        let getSection = service.getSection(ofType: sectionType)
//            .share()
//
//        getSection
//            .map { $0.preview.title }
//            .replaceError(with: "")
////            .print()
//            .assign(to: \.title, on: self)
//            .store(in: &subscriptions)
//
//        getSection
//            .map { $0.preview.subtitle }
//            .replaceError(with: "")
//            .assign(to: \.subtitle, on: self)
//            .store(in: &subscriptions)
//
//        getSection
        service.getSection(ofType: sectionType)
//            .delay(for: .seconds(3), scheduler: RunLoop.main, options: .none)
            
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
                self?.subtitle = section.preview.subtitle
                self?.newFirstImagePath = self?.firstImageURL
//                self?.currentFirstImagePath = section.firstImageURL
                self?.newSecondImagePath = self?.secondImageURL
//                self?.currentSecondImagePath = section.secondImageURL
            }
            .store(in: &subscriptions)
    }
    
    func saveSection() {
        isLoading = true
        let newSection = SectionAPIModel(
            type: sectionType,
            preview: SectionAPIModel.Preview(
                title: title,
                subtitle: subtitle
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
                self?.subtitle = section.preview.subtitle
                self?.newFirstImagePath = self?.firstImageURL
//                self?.currentFirstImagePath = section.firstImageURL
                self?.newSecondImagePath = self?.secondImageURL
//                self?.currentSecondImagePath = section.secondImageURL
            }
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
        if let imagePath = newFirstImagePath, imagePath != firstImageURL {
            return service.addFirstImage(from: imagePath, for: sectionType)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    private func addNewSecondImageIfNeeded() -> AnyPublisher<Void, Error> {
        if let imagePath = newSecondImagePath, imagePath != secondImageURL {
            return service.addSecondImage(from: imagePath, for: sectionType)
        } else {
            return Just(())
                .ignoreOutput()
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
