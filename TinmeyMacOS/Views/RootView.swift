//
//  RootView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 18.08.2021.
//

import SwiftUI

struct RootView: View {
//    @ObservedObject var viewModel = RootViewModel()
    @State
    private var selectedSection: AppSection = .works
    private let sections = AppSection.allCases
    
    var body: some View {
        NavigationView {
//            TabView {
//                ForEach(sections, id: \.self) { section in
//                    NavigationView {
//                        destination(for: section)
//                    }
//                    .tabItem {
//                        Label {
//                            Text(section.title)
//                        } icon: {
//                            Image(systemName: section.imageName)
//                        }
//                    }
//                }
//            }
            List {
                ForEach(sections, id: \.self) { section in
                    NavigationLink {
                        destination(for: section)
                    } label: {
                        Label {
                            Text(section.title)
                        } icon: {
                            Image(systemName: section.imageName)
                        }
                    }
                }
            }
            .frame(minWidth: 200)
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
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
