//
//  LoadableViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 07.04.2022.
//

import Foundation

protocol LoadableViewModel: AnyObject {
    var loadingDebounceTimer: Timer? { get set }
    var startLoadingDelay: TimeInterval { get }
    func onNew(loadingState: Bool)
}

extension LoadableViewModel {
    var startLoadingDelay: TimeInterval { 0.3 }
    
    func startLoading() {
        loadingDebounceTimer = Timer.scheduledTimer(withTimeInterval: startLoadingDelay, repeats: false) { [weak self] _ in
            self?.onNew(loadingState: true)
        }
    }
    
    func stopLoading() {
        loadingDebounceTimer?.invalidate()
        loadingDebounceTimer = nil
        onNew(loadingState: false)
    }
}
