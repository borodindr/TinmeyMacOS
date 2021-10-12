//
//  EditProfileViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 12.10.2021.
//

import SwiftUI
import Combine
import TinmeyCore

final class EditProfileViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var alert: AlertType? = nil
    @Published var name = ""
    @Published var email = ""
    @Published var currentStatus = ""
    @Published var shortAbout = ""
    @Published var about = NSAttributedString()
    
    private let service = ProfileAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
//        getProfile()
    }
    
    func getProfile() {
        isLoading = true
        alert = nil
        service.getProfile()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] profile in
                self?.name = profile.name
                self?.email = profile.email
                self?.currentStatus = profile.currentStatus
                self?.shortAbout = profile.shortAbout
                self?.about = NSAttributedString(string: profile.about, attributes: [
                    :
                ])
            }
            .store(in: &subscriptions)
    }
    
    func updateProfile() {
        let newProfile = ProfileAPIModel(
            name: name,
            email: email,
            currentStatus: currentStatus,
            shortAbout: shortAbout,
            about: about.string
        )
        isLoading = true
        service.update(to: newProfile)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.alert = .success(message: "Successfully saved profile")
                case .failure(let error):
                    self?.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] profile in
                self?.name = profile.name
                self?.email = profile.email
                self?.currentStatus = profile.currentStatus
                self?.shortAbout = profile.shortAbout
                self?.about = NSAttributedString(string: profile.about, attributes: [
                    :
                ])
            }
            .store(in: &subscriptions)
    }
}

