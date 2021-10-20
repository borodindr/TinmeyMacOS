//
//  TagInputView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import SwiftUI

struct TagInputView: View {
    @State var name = ""
    var onSave: (String) -> ()
    
    var body: some View {
        HStack {
            TextField("Enter new tag name", text: $name)
                .font(.caption)
                .fixedSize()
            Button {
                onSave(name)
                name = ""
            } label: {
                Image("add")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(Color.blue)
        .clipShape(Capsule())
    }
}

struct TagInputView_Previews: PreviewProvider {
    static var previews: some View {
        TagInputView() { _ in }
    }
}
