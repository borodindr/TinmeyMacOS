//
//  SettingsView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.10.2021.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    
    
    var body: some View {
        List {
            if viewModel.isAuthorized {
                VStack(alignment: .leading) {
                    Text("Authorized")
                    Button {
                        viewModel.logout()
                    } label: {
                        Text("Logout")
                    }
                    .disabled(viewModel.isLoading)
                }
            } else {
                VStack {
                    Text("Authorize")
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        viewModel.login()
                    } label: {
                        Text("Login")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
