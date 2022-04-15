//
//  ItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI
import TinmeyCore

struct ItemView<Item: ItemObject>: View {
    var item: Item
    var onMoveLeft: ((Item) -> ())?
    var onMoveRight: ((Item) -> ())?
    var onEdit: (Item) -> ()
    var onDelete: (Item) -> ()
    
    var body: some View {
        image
            .overlayOnHover(overlay: {
                overlay
            })
    }
    
    private var image: some View {
        ItemImageView(imageURL: item.images.first?.url)
    }
    
    private var overlay: some View {
        VStack(spacing: 16) {
            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.title)
                Text(item.description)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            controls
        }
        .padding()
    }
    
    private var controls: some View {
        HStack(spacing: 24) {
            if needArrows {
                HStack(spacing: 8) {
                    if let onMoveLeft = onMoveLeft {
                        IconButton("arrow.left") {
                            onMoveLeft(item)
                        }
                    }
                    
                    if let onMoveRight = onMoveRight {
                        IconButton("arrow.right") {
                            onMoveRight(item)
                        }
                    }
                }
            }
            
            IconButton("square.and.pencil") {
                onEdit(item)
            }
            
            IconButton("trash") {
                onDelete(item)
            }
            .foregroundColor(.red)
        }
    }
    
    private var needArrows: Bool {
        onMoveLeft != nil || onMoveRight != nil
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: Work.preview) { _ in
            
        } onDelete: { _ in
            
        }

        
    }
}
