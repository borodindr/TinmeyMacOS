//
//  WorkItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 26.12.2021.
//

import SwiftUI

struct WorkItemView: View {
    let work: Work
    let item: Work.Item

    var body: some View {
        switch item {
        case .body(let work):
            WorkItemBodyView(work: work)
        case .image(let data):
            if let path = data.path {
                WorkItemImageView(imagePath: path)
            } else {
                WorkItemClearView()
            }
        }
    }
}

struct WorkItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorkItemView(work: .preview, item: .previewBody)
            WorkItemView(work: .preview, item: .previewImage)
            WorkItemView(work: .preview, item: .previewClear)
        }
    }
}
