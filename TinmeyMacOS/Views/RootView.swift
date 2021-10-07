//
//  RootView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 18.08.2021.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = RootViewModel()
    
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
                    Text("Home")
                case .covers:
                    WorksListView(workType: .cover)
                case .layouts:
                    WorksListView(workType: .layout)
                case .settings:
                    Text("Settings")
                }
            }
            .frame(minWidth: 250, maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
