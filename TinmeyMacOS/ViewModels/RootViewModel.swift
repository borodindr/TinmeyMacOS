//
//  RootViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 20.08.2021.
//

import SwiftUI

class RootViewModel: ObservableObject {
    @Published var selectedSection: AppSection = .home
    
    var mainSections: [AppSection] = [.home, .covers, .layouts]
}
