//
//  BoxLinkButton.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import SwiftUI

struct BoxLinkButton: View {
    let text: String
    var action: (() -> ())? = nil
    
    var body: some View {
        Button(action: action ?? { }) {
            Text(text)
                .font(.system(size: 13))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 7)
        .padding(.vertical, 5)
        .background(Color.secondary)
        .cornerRadius(2.5)
    }
}

struct BoxLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        BoxLinkButton(text: "See more")
    }
}
