//
//  SettingsViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import SwiftUI
import Combine
import TinmeyCore

final class SettingsViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var alert: AlertType? = nil
    @Published var username = ""
    @Published var password = ""
    @Published var isAuthorized = AuthAPIService.isAuthorized
    
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var repeatNewPassword = ""
    
    var loadingDebounceTimer: Timer?
    
    private let service = AuthAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    func login() {
        startLoading()
        service.login(username: username, password: password)
            .sink { [weak self] completion in
                self?.stopLoading()
                self?.isAuthorized = AuthAPIService.isAuthorized
                self?.username = ""
                self?.password = ""
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { user in
                
            }
            .store(in: &subscriptions)
    }
    
    func logout() {
        service.logout()
        isAuthorized = AuthAPIService.isAuthorized
    }
    
    func changePassword() {
        startLoading()
        service
            .change(
                currentPassword: currentPassword,
                to: newPassword,
                repeatNewPassword: repeatNewPassword
            )
            .sink { [weak self] completion in
                self?.stopLoading()
                self?.currentPassword = ""
                self?.newPassword = ""
                self?.repeatNewPassword = ""
                switch completion {
                case .finished:
                    self?.alert = .success(message: "Successfully changed password")
                case .failure(let error):
                    self?.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { user in
                
            }
            .store(in: &subscriptions)
    }
}

extension SettingsViewModel: LoadableViewModel {
    func onNew(loadingState: Bool) {
        isLoading = loadingState
    }
}
