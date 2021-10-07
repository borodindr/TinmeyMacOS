////
////  WorkPreviewViewModel.swift
////  TinmeyMacOS
////
////  Created by Dmitry Borodin on 29.08.2021.
////
//
//import SwiftUI
//import TinmeyCore
//import Combine
//
//final class WorkPreviewViewModel: ObservableObject {
//    let workPreview: Work
//    @Published private(set) var workImageData: Data?
//
//    private let service: WorksAPIService
//    private var subscriptions = Set<AnyCancellable>()
//
//    init(workPreview: Work) {
//        self.workPreview = workPreview
//        self.service = WorksAPIService(workType: .cover)
//    }
//
//    func loadImage() {
//        guard let id = workPreview.imageID else { return }
//        service.loadImage(workImageID: id)
//            .sink { [weak self] completion in
//
//            } receiveValue: { [weak self] data in
//                self?.workImageData = data
//            }
//            .store(in: &subscriptions)
//    }
//
//}
