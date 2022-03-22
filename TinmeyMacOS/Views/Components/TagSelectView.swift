//
//  TagSelectView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import SwiftUI

struct TagSelectView: View {
    @Binding var selectedTags: [String]
    var availableTags: [String]
    
    @State private var selectedTagIndex: Int = -1
    private var disableAddButton: Bool {
        selectedTagIndex < 0 || selectedTagIndex >= availableTags.count
    }
    
    var body: some View {
        HStack {
            Picker("", selection: $selectedTagIndex) {
                ForEach(0..<availableTags.count, id: \.self) { index in
                    Text(availableTags[index]).tag(index)
                }
            }
            .frame(minWidth: 100)
            .fixedSize()
            
            
            IconButton("plus.square") {
                addTag(at: selectedTagIndex)
            }
            .disabled(disableAddButton)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .padding(.trailing, 4)
        .background(Color.blue)
        .clipShape(Capsule())
    }
    
    private func addTag(at tagIndex: Int) {
        let tagToAdd = availableTags[tagIndex]
        guard !selectedTags.contains(tagToAdd) else { return }
        selectedTags.append(tagToAdd)
    }
}

struct TagSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TagSelectView(selectedTags: .constant(["tag"]),
                      availableTags: ["Some", "tags", "data", "source source source"])
    }
}
