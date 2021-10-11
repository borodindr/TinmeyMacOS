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
    @Published var error: ErrorDescription? = nil
    @Published var username = ""
    @Published var password = ""
    @Published var isAuthorized = AuthAPIService.isAuthorized
    
    private let service = AuthAPIService()
    private var subscriptions = Set<AnyCancellable>()
    
    func login() {
        isLoading = true
        service.login(username: username, password: password)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isAuthorized = AuthAPIService.isAuthorized
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    self?.isAuthorized = AuthAPIService.isAuthorized
                    self?.error = ErrorDescription(text: error.localizedDescription)
                }
            } receiveValue: { user in
                
            }
            .store(in: &subscriptions)
    }
    
    func logout() {
        service.logout()
        isAuthorized = AuthAPIService.isAuthorized
    }
}
