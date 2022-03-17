//
//  OverlayOnHoverViewModifier.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 15.03.2022.
//

import SwiftUI

struct OverlayOnHoverViewModifier<Overlay: View>: ViewModifier {
    var withDimming: Bool
    var overlay: () -> Overlay
    
    @State
    private var showControls = false
    
    func body(content: Content) -> some View {
        content
            .overlay(_overlay)
            .onHover { hovering in
                withAnimation {
                    showControls = hovering
                }
            }
    }
        
    @ViewBuilder
    private var _overlay: some View {
        if showControls {
            (withDimming ? Color.black.opacity(0.7) : .clear)
                .overlay(overlay())
        }
    }
}

extension View {
    func overlayOnHover<Overlay: View>(withDimming: Bool = true, overlay: @escaping () -> Overlay) -> some View {
        modifier(OverlayOnHoverViewModifier(withDimming: withDimming, overlay: overlay))
    }
}
