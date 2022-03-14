//
//  RootView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 18.08.2021.
//

import SwiftUI

struct RootView: View {
    @State
    private var selectedSection: AppSection? = .works
    private let sections: [[AppSection]] = [
        [.works, .layouts],
        [.settings]
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sections, id: \.self) { section in
                    Section {
                        ForEach(section, id: \.self) { item in
                            NavigationLink(tag: item, selection: $selectedSection) {
                                destination(for: item)
                            } label: {
                                Label {
                                    Text(item.title)
                                } icon: {
                                    Image(systemName: item.imageName)
                                }
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 200)
            .toolbar {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.leading")
                }
            }
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func destination(for section: AppSection) -> some View {
        switch section {
        case .works:
            WorksListView()
        case .layouts:
            Text("In development :(")
        case .settings:
            SettingsView()
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?
            .firstResponder?
            .tryToPerform(
                #selector(NSSplitViewController.toggleSidebar(_:)),
                with: nil
            )
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
