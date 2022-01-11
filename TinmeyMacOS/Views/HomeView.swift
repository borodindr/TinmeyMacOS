//
//  HomeView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import SwiftUI
import TinmeyCore

struct HomeView: View {
    private let sections: [SectionAPIModel.SectionType] = [
        .covers,
        .layouts]
    
    
    var body: some View {
        content
    }
    
    
    var content: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack {
                    Text("Profile")
                        .font(.title)
                    EditProfileView()
                }
                
                VStack {
                    Text("Sections")
                        .font(.title)
                    ForEach(sections, id: \.self) { section in
                        EditSectionView(sectionType: section)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
