//
//  MultilineTextView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 05.10.2021.
//

import Foundation
import SwiftUI

struct TextView: View {
    @Binding var text: String
    private var font: NSFont = .systemFont(ofSize: 12)
    private var minHeight: CGFloat = 0
    private var backgroundColor: NSColor? = nil
    private var textColor: NSColor? = nil
    private var placeholderText: String = ""

    init(text: Binding<String>) {
        self._text = text
    }

    var body: some View {
        TextViewWrapper(text: $text,
                        font: font,
                        minHeight: minHeight,
                        backgroundColor: backgroundColor,
                        textColor: textColor)
            .padding(4)
            .background(Color.black)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.secondary, lineWidth: 0.5)
            )
            .background(placeholderView, alignment: .topLeading)
    }
    
    private var placeholderView: some View {
        Text(placeholderText)
            // Convert NSFont
            .font(.system(size: font.pointSize))
            .opacity(text.isEmpty ? 0.3 : 0)
            .padding(.leading, 5)
            .animation(.easeInOut(duration: 0.15))
    }
    
}

// MARK: - Font
extension TextView {
    func font(_ font: NSFont) -> Self {
        var textView = self
        textView.font = font
        return textView
    }
    
    func fontSize(_ fontSize: CGFloat, weight: NSFont.Weight = .regular) -> Self {
        font(.systemFont(ofSize: fontSize, weight: weight))
    }
    
}

// MARK: - Min height
extension TextView {
    func minHeight(_ minHeight: CGFloat) -> Self {
        var textView = self
        textView.minHeight = minHeight
        return textView
    }
}

// MARK: - Background color
extension TextView {
    func backgroundColor(_ backgroundColor: NSColor) -> Self {
        var textView = self
        textView.backgroundColor = backgroundColor
        return textView
    }
}

// MARK: - Text color
extension TextView {
    func textColor(_ textColor: NSColor) -> Self {
        var textView = self
        textView.textColor = textColor
        return textView
    }
}

// MARK: - Placeholder
extension TextView {
    func placeholder(_ placeholderText: String) -> Self {
        var textView = self
        textView.placeholderText = placeholderText
        return textView
    }
}

// MARK: - Wrapper
fileprivate struct TextViewWrapper: NSViewRepresentable {
    @Binding var text: String
    var font: NSFont
    var minHeight: CGFloat
    var backgroundColor: NSColor?
    var textColor: NSColor?
    
    func makeNSView(context: Context) -> NSTextView {
        context.coordinator.textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        if nsView.string != text {
            nsView.string = text
        }
        context.coordinator.updateHeight()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            font: font,
            minHeight: minHeight,
            backgroundColor: backgroundColor,
            textColor: textColor
        )
    }
}

// MARK: - Wrapper Coordinator
extension TextViewWrapper {
    fileprivate class Coordinator: NSObject, NSTextViewDelegate {
        var textView: NSTextView
        @Binding var text: String
        private var minHeight: CGFloat
        private lazy var heightConstraint: NSLayoutConstraint = textView.heightAnchor.constraint(equalToConstant: 0)
        
        init(
            text: Binding<String>,
            font: NSFont,
            minHeight: CGFloat,
            backgroundColor: NSColor?,
            textColor: NSColor?
        ) {
            self.textView = NSTextView()
            self._text = text
            self.minHeight = minHeight
            super.init()

            // Appearance
            textView.usesAdaptiveColorMappingForDarkAppearance = true
            textView.font = font
            textView.drawsBackground = false
            if let textColor = textColor {
                textView.textColor = textColor
            }
            textView.isRichText = false

            // Functionality (more available)
            textView.allowsUndo = true
            textView.isAutomaticLinkDetectionEnabled = true
            textView.isAutomaticDataDetectionEnabled = true
            textView.isContinuousSpellCheckingEnabled = true
            
            textView.delegate = self
            textView.string = text.wrappedValue
            textView.translatesAutoresizingMaskIntoConstraints = false
            heightConstraint.isActive = true
            updateHeight()
        }
        
        func updateHeight() {
            let contentHeight = textView.contentSize.height
            let newHeight = max(contentHeight, minHeight)
            heightConstraint.constant = newHeight
        }
        
        func textDidChange(_ notification: Notification) {
            text = textView.string
            updateHeight()
        }
    }
}
