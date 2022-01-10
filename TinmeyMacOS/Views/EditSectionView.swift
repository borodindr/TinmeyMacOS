//
//  EditSectionView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import SwiftUI
import TinmeyCore

struct EditSectionView: View {
    @ObservedObject var viewModel: EditSectionViewModel
    
    init(sectionType: SectionAPIModel.SectionType) {
        self.viewModel = EditSectionViewModel(sectionType: sectionType)
    }
    
    var body: some View {
        ZStack {
            content
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    ProgressIndicator(size: .regular)
                    Spacer()
                }
            } else if case let .error(message) = viewModel.alert {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    Text("Error loading \(viewModel.sectionType.rawValue) section")
                        .font(.title)
                    Text(message)
                        .font(.body)
                    Button(action: viewModel.loadSection) {
                        Text("Reload")
                    }
                    Spacer()
                }
            } else if case let .success(message) = viewModel.alert {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    Text("Success")
                        .font(.title)
                    Text(message)
                        .font(.body)
                    Button {
                        viewModel.alert = nil
                    } label:  {
                        Text("Close")
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.loadSection()
        }
    }
    
    var content: some View {
        VStack(spacing: 16) {
            VStack {
                HStack {
                    Text(viewModel.sectionType.rawValue.capitalized)
                        .font(.headline)
                    Spacer()
                }
                textField("Title", text: $viewModel.title)
                textField("Subtitle", text: $viewModel.subtitle)
                textField("Preview subtitle", text: $viewModel.previewSubtitle)
            }
            HStack {
                firstImageBox
                secondImageBox
            }
            if AuthAPIService.isAuthorized {
                Button(action: viewModel.saveSection) {
                    Text("Save \(viewModel.sectionType.rawValue) section")
                }
            }
        }
        .padding()
    }
    
    func textField(_ placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Text(placeholder)
                .multilineTextAlignment(.trailing)
                .frame(width: 100, alignment: .trailing)
            TextField("", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(!AuthAPIService.isAuthorized)
        }
    }
    
    var firstImageBox: some View {
        VStack(spacing: 8) {
            EditSectionImageView(remoteImage: viewModel.firstImage,
                                 newImageURL: $viewModel.newFirstImageURL)
        }
    }
    
    var secondImageBox: some View {
        VStack(spacing: 8) {
            EditSectionImageView(remoteImage: viewModel.secondImage,
                                 newImageURL: $viewModel.newSecondImageURL)
        }
    }
}

struct EditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSectionView(sectionType: .covers)
    }
}
