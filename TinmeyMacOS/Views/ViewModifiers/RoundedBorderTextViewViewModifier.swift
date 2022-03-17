//
//  RoundedBorderTextViewViewModifier.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 16.03.2022.
//

import SwiftUI

struct RoundedBorderTextViewViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary)
                    .opacity(0.5)
            )
    }
}

extension TextEditor {
    func roundedBorderTextView() -> some View {
        modifier(RoundedBorderTextViewViewModifier())
    }
}
