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
    
    func textField(_ placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Text(placeholder)
                .multilineTextAlignment(.trailing)
                .frame(width: 100, alignment: .trailing)
            TextField("", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    func multilineTextField(_ placeholder: String, text: Binding<NSAttributedString>) -> some View {
        HStack {
            Text(placeholder)
                .multilineTextAlignment(.trailing)
                .frame(width: 100, alignment: .trailing)
            MultilineTextField(
                NSAttributedString(),
                text: text,
                nsFont: .systemFont(ofSize: 12)
            )
                .padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.secondary, lineWidth: 0.5)
                )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
