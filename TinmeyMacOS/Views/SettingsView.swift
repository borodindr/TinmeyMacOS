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
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading) {
                        Text("Authorized")
                        Button(action: viewModel.logout) {
                            Text("Logout")
                        }
                        .disabled(viewModel.isLoading)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Change password:")
                        SecureField("Current password", text: $viewModel.currentPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("New password", text: $viewModel.newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Repeat new password", text: $viewModel.repeatNewPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: viewModel.changePassword) {
                            Text("Change password")
                        }
                    }
                }
                .frame(width: 300)
            } else {
                VStack(alignment: .leading) {
                    Text("Authorize")
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: viewModel.login) {
                        Text("Login")
                    }
                    .disabled(viewModel.isLoading)
                }
                .frame(width: 300)
            }
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("Close"))
            )
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
