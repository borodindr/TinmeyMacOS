//
//  RootViewModel.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 20.08.2021.
//

import SwiftUI

class RootViewModel: ObservableObject {
    @Published var selectedSection: AppSection = .works
    
    var mainSections: [AppSection] = [.works, .layouts]
}
