//
//  DimmedLoadingViewModifier.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 07.04.2022.
//

import SwiftUI

fileprivate struct DimmedLoadingViewModifier: ViewModifier {
    let isLoading: Bool
    
    init(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    ProgressIndicator(size: .regular)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func dimmedLoading(_ isLoading: Bool) -> some View {
        modifier(DimmedLoadingViewModifier(isLoading))
    }
}
