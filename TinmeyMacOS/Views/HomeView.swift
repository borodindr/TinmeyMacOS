//
//  HomeView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import SwiftUI
import TinmeyCore

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    private let sections: [SectionAPIModel.SectionType] = [
        .covers,
        .layouts]
    
    
    var body: some View {
//        ZStack {
            content
//            if viewModel.isLoading {
//                Color.black.opacity(0.5)
//                VStack {
//                    Spacer()
//                    ProgressIndicator(size: .regular)
//                    Spacer()
//                }
//            } else if case let .error(message) = viewModel.alert {
//                Color.black.opacity(0.5)
//                VStack {
//                    Spacer()
//                    Text("Error loading profile")
//                        .font(.title)
//                    Text(message)
//                        .font(.body)
//                    Button(action: viewModel.getProfile) {
//                        Text("Reload")
//                    }
//                    Spacer()
//                }
//            }
//        }
//        .onAppear {
//            viewModel.getProfile()
//        }
    }
    
    
    var content: some View {
        List {
//            textField("Current status", text: $viewModel.currentStatus)
//            EditSectionView(sectionType: .covers)
            VStack(spacing: 32) {
                VStack {
                    Text("Profile")
                        .font(.title)
                    EditProfileView()
//                    Form {
//                        textField("Name", text: $viewModel.name)
//                        textField("Email", text: $viewModel.email)
//                        textField("Current status", text: $viewModel.currentStatus)
//                        textField("Short about", text: $viewModel.shortAbout)
//                        multilineTextField("About", text: $viewModel.about)
//                        Button(action: viewModel.updateProfile) {
//                            Text("Save profile")
//                        }
//                    }
//                    .padding()
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
//            TextField("", text: text)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
