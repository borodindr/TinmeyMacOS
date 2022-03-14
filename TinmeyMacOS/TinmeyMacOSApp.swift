//
//  TinmeyMacOSApp.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.03.2022.
//

import SwiftUI

@main
struct TinmeyMacOSApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(idealWidth: 1200, idealHeight: 1000)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem, addition: { })
        }
    }
}
