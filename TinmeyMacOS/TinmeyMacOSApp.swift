//
//  TinmeyMacOSApp.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.03.2022.
//

import SwiftUI

@main
struct TinmeyMacOSApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(idealWidth: 1200, idealHeight: 1000)
        }
    }
}
