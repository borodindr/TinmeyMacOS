//
//  IconButton.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 14.12.2021.
//

import SwiftUI

struct IconButton: View {
    let iconName: String
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .scaledToFit()
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 15, height: 15)
    }
}
