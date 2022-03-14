//
//  EditWorkItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditWorkItemView: View {
    @Binding var item: Work.Item.Create
    @Binding var work: Work.Create
    
    let onMoveBackward: ((Work.Item.Create) -> ())?
    let onMoveForward: ((Work.Item.Create) -> ())?
    
    private var onMoveBodyBackward: (() -> ())? {
        onMoveBackward == nil ? nil : { onMoveBackward?(item) }
    }
    
    private var onMoveBodyForward: (() -> ())? {
        onMoveForward == nil ? nil : { onMoveForward?(item) }
    }
    
    var body: some View {
        switch item {
        case .body:
            EditWorkItemBodyView(
                title: $work.title,
                description: $work.description,
                tags: $work.tags,
                onMoveBackward: onMoveBackward == nil ? nil : { onMoveBackward?(item) },
                onMoveForward: onMoveForward == nil ? nil : { onMoveForward?(item) }
            )
        case .image(let data):
            EditWorkItemImageView(
                remoteImage: data.currentImage,
                newImageURL: Binding(get: {
                    data.newImageURL
                }, set: { newValue in
                    work.images[data.id]?.newImageURL = newValue
                }),
                onClearImage: { work.images[data.id]?.clear() },
                onMoveBackward: onMoveBackward == nil ? nil : { onMoveBackward?(item) },
                onMoveForward: onMoveForward == nil ? nil : { onMoveForward?(item) }
            )
        }
    }
}

/*
struct EditWorkItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditWorkItemView(
                item: .constant(.body),
                work: .constant(Work.Create(Work.preview)),
                onMoveBackward: { _ in },
                onMoveForward: { _ in }
            )
            EditWorkItemView(
                item: .constant(.body),
                work: .constant(Work.Create(Work.preview)),
                onMoveBackward: nil,
                onMoveForward: nil
            )
            EditWorkItemView(
                item: .constant(.image(.clear)),
                work: .constant(Work.Create(Work.preview)),
                onMoveBackward: { _ in },
                onMoveForward: { _ in }
            )
            EditWorkItemView(
                item: .constant(.image(.clear)),
                work: .constant(Work.Create(Work.preview)),
                onMoveBackward: nil,
                onMoveForward: nil
            )
        }
    }
}
*/
