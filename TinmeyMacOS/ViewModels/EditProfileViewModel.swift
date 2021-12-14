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
    @Published var location = ""
    @Published var shortAbout = ""
    @Published var about = ""
    
    private let service = ProfileAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    
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
                self?.location = profile.location
                self?.shortAbout = profile.shortAbout
                self?.about = profile.about
            }
            .store(in: &subscriptions)
    }
    
    func updateProfile() {
        let newProfile = ProfileAPIModel(
            name: name,
            email: email,
            location: location,
            shortAbout: shortAbout,
            about: about
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
                self?.location = profile.location
                self?.shortAbout = profile.shortAbout
                self?.about = profile.about
            }
            .store(in: &subscriptions)
    }
}

