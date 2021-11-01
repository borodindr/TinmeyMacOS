//
//  TextArea.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 01.11.2021.
//

import Foundation
import SwiftUI

struct TextArea: NSViewRepresentable {
    @Binding var text: String
    var font: NSFont = .systemFont(ofSize: 12)
    var textColor: NSColor = .textColor

    func makeNSView(context: Context) -> NSScrollView {
        context.coordinator.createTextViewStack()
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textArea = nsView.documentView as? NSTextView, textArea.string != self.text {
            let attributedText = NSAttributedString(string: self.text, attributes: [
                .font: font,
                .foregroundColor: textColor
            ])
            textArea.textStorage?.setAttributedString(attributedText)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, font: font, textColor: textColor)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var text: Binding<String>
        var font: NSFont
        var textColor: NSColor

        init(text: Binding<String>, font: NSFont, textColor: NSColor) {
            self.text = text
            self.font = font
            self.textColor = textColor
        }

        func textView(_ textView: NSTextView, shouldChangeTextIn range: NSRange, replacementString text: String?) -> Bool {
            self.text.wrappedValue = (textView.string as NSString).replacingCharacters(in: range, with: text!)
            let attributedText = NSAttributedString(string: self.text.wrappedValue, attributes: [
                .font: font,
                .foregroundColor: textColor
            ])
            textView.textStorage?.setAttributedString(attributedText)
            return false
        }

        fileprivate lazy var textStorage = NSTextStorage()
        fileprivate lazy var layoutManager = NSLayoutManager()
        fileprivate lazy var textContainer = NSTextContainer()
        fileprivate lazy var textView: NSTextView = NSTextView(frame: CGRect(), textContainer: textContainer)
        fileprivate lazy var scrollview = NSScrollView()

        func createTextViewStack() -> NSScrollView {
            let contentSize = scrollview.contentSize

            textContainer.containerSize = CGSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            textContainer.widthTracksTextView = true

            textView.minSize = CGSize(width: 0, height: 0)
            textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            textView.isVerticallyResizable = true
            textView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
            textView.autoresizingMask = [.width]
            textView.delegate = self

            scrollview.borderType = .noBorder
            scrollview.hasVerticalScroller = true
            scrollview.documentView = textView

            textStorage.addLayoutManager(layoutManager)
            layoutManager.addTextContainer(textContainer)

            return scrollview
        }
    }
}
