//
//  NSTextView+Extension.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.01.2022.
//

import AppKit

extension NSTextView {
    var contentSize: CGSize {
        guard let layoutManager = layoutManager, let textContainer = textContainer else {
            print("textView no layoutManager or textContainer")
            return .zero
        }

        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
    }
    
    open override var frame: CGRect {
            didSet {
                backgroundColor = .clear
                drawsBackground = true
            }

        }
}
