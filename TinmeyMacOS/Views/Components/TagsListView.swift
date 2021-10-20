//
//  TagsListView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import SwiftUI
import WrappingHStack

struct TagsListView: View {
    var tags: [String]
    var onDelete: ((String) -> ())?
    
    init(tags: [String]) {
        self.tags = tags
        self.onDelete = nil
    }
    
    init(
        tags: [String],
        onDelete: @escaping ((String) -> ())
    ) {
        self.tags = tags
        self.onDelete = onDelete
    }
    
    var body: some View {
        WrappingHStack(tags, id: \.self, spacing: .constant(0)) { tagName in
            TagView(
                name: tagName,
                onDelete: onDelete != nil ? { onDelete?(tagName) } : nil)
                .padding(4)
        }
    }
    
    
}

struct TagsListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TagsListView(tags: Work.preview.tags)
            TagsListView(
                tags: ["Some", "tags", "data", "source"],
                onDelete: { deletedTag in }
            )
        }
        .frame(width: 250, height: 200)
    }
}
