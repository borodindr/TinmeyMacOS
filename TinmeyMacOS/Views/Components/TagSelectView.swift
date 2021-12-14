//
//  TagSelectView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import SwiftUI

struct TagSelectView: View {
    var availableTags: [String]
    var onSelect: (String) -> ()
    
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
            
            Button {
                onSelect(availableTags[selectedTagIndex])
            } label: {
                Image(nsImage: NSImage(named: NSImage.touchBarAddTemplateName)!)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(disableAddButton)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(Color.blue)
        .clipShape(Capsule())
    }
}

struct TagSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TagSelectView(availableTags: ["Some", "tags", "data", "source source source"]) { _ in }
    }
}
