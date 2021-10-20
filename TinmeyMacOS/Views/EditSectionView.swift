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
            Button(action: viewModel.saveSection) {
                Text("Save \(viewModel.sectionType.rawValue) section")
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
        }
    }
    
    var firstImageBox: some View {
        VStack(spacing: 8) {
            WorkViewImageBox(imageURL: viewModel.newFirstImagePath)
                .background(Color.black)
                .border(Color.gray, width: 1)
            firstImageBoxControls
        }
    }
    
    var secondImageBox: some View {
        VStack(spacing: 8) {
            WorkViewImageBox(imageURL: viewModel.newSecondImagePath)
                .background(Color.black)
                .border(Color.gray, width: 1)
            secondImageBoxControls
        }
    }
    
    var firstImageBoxControls: some View {
        HStack {
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK, let url = panel.url {
                    viewModel.newFirstImagePath = url
                }
            } label: {
                Text("Select")
            }
            if viewModel.newFirstImagePath != viewModel.firstImageURL {
                Button {
                    viewModel.newFirstImagePath = viewModel.firstImageURL
                } label: {
                    Text("Reset")
                }
            }
        }
    }
    
    var secondImageBoxControls: some View {
        HStack {
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK, let url = panel.url {
                    viewModel.newSecondImagePath = url
                }
            } label: {
                Text("Select")
            }
            if viewModel.newSecondImagePath != viewModel.secondImageURL {
                Button {
                    viewModel.newSecondImagePath = viewModel.secondImageURL
                } label: {
                    Text("Reset")
                }
            }
        }
    }
}

struct EditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSectionView(sectionType: .covers)
    }
}
