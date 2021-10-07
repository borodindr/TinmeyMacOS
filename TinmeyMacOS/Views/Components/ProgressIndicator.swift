//
//  ProgressIndicator.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 31.08.2021.
//

import SwiftUI

struct ProgressIndicator: NSViewRepresentable {
    var isAnimating: Bool = true
    var style: NSProgressIndicator.Style = .spinning
    var size: NSControl.ControlSize = .regular
    
    func makeNSView(context: Context) -> NSProgressIndicator {
        let loader = NSProgressIndicator()
        loader.style = style
        loader.isIndeterminate = true
//        loader.autoresizingMask = [.width, .height]
        loader.controlSize = size
        return loader
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        isAnimating ? nsView.startAnimation(self) : nsView.stopAnimation(self)
    }
}
