//
//  EditProfileView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 12.10.2021.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel = EditProfileViewModel()
    
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
                    Text("❌ Error loading profile")
                        .font(.title)
                    Text(message)
                        .font(.body)
                    Button(action: viewModel.getProfile) {
                        Text("Reload")
                    }
                    Spacer()
                }
            } else if case let .success(message) = viewModel.alert {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    Text("✅ Success")
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
            viewModel.getProfile()
        }
    }
    
    var content: some View {
        VStack {
            textField("Name", text: $viewModel.name)
            textField("Email", text: $viewModel.email)
            textField("Location", text: $viewModel.location)
            multilineTextField("Short about", text: $viewModel.shortAbout)
            multilineTextField("About", text: $viewModel.about)
            if AuthAPIService.isAuthorized {
                Button(action: viewModel.updateProfile) {
                    Text("Save profile")
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
                .background(Color.black)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.secondary, lineWidth: 0.5)
                )
                .disabled(!AuthAPIService.isAuthorized)
        }
    }
    
    func multilineTextField(_ placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Text(placeholder)
                .multilineTextAlignment(.trailing)
                .frame(width: 100, alignment: .trailing)
            TextView(text: text)
                .font(.systemFont(ofSize: 12))
                .disabled(!AuthAPIService.isAuthorized)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
