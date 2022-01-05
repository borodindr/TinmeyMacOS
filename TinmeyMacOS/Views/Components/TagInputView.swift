//
//  TagInputView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import SwiftUI

struct TagInputView: View {
    @Binding var tags: [String]
    @State private var name = ""
    private var disableAddButton: Bool {
        name == ""
    }
    
    var body: some View {
        HStack {
            TextField("Enter new tag name", text: $name)
                .font(.caption)
                .fixedSize()
            IconButton("add") {
                addTag(name)
                name = ""
            }
            .disabled(disableAddButton)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .padding(.trailing, 4)
        .background(Color.blue)
        .clipShape(Capsule())
    }
    
    private func addTag(_ tagToAdd: String) {
        guard !tags.contains(tagToAdd) else { return }
        tags.append(tagToAdd)
    }
}

struct TagInputView_Previews: PreviewProvider {
    static var previews: some View {
        TagInputView(tags: .constant(["tag"]))
    }
}
