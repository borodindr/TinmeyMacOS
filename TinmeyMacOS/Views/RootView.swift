//
//  RootView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 18.08.2021.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel = RootViewModel()
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                ForEach(viewModel.mainSections, id: \.self) { section in
                    TabButton(section: section, selectedSection: $viewModel.selectedSection)
                }
                Spacer()
                TabButton(section: .settings, selectedSection: $viewModel.selectedSection)
            }
            .padding()
            .padding(.top, 35)
            .background(BlurView())
            
            ZStack {
                switch viewModel.selectedSection {
                case .home:
                    HomeView()
                case .covers:
                    WorksListView(workType: .cover)
                case .layouts:
                    WorksListView(workType: .layout)
                case .settings:
                    SettingsView()
                }
            }
            .frame(minWidth: 250, maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
