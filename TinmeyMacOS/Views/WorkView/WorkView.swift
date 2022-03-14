//
//  BookCoverView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI
import TinmeyCore

struct WorkView: View {
    var work: Work
    var onMoveLeft: ((Work) -> ())?
    var onMoveRight: ((Work) -> ())?
    var onEdit: (Work) -> ()
    var onDelete: (Work) -> ()
    
    @State
    private var showControls = false
    
    var body: some View {
        image
            .overlay(overlay)
            .onHover { hovering in
                withAnimation {
                    showControls = hovering
                }
        }
    }
    
    private var image: some View {
        WorkItemImageView(imagePath: work.images.first?.path)
    }
    
    @ViewBuilder
    private var overlay: some View {
        if showControls {
            VStack(spacing: 16) {
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text(work.title)
                        .font(.title)
                    Text(work.description)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                controls
            }
            .padding()
            .background(
                Color.black.opacity(0.7)
            )
        }
    }
    
    private var controls: some View {
        HStack(spacing: 24) {
            if needArrows {
                HStack(spacing: 8) {
                    if let onMoveLeft = onMoveLeft {
                        IconButton("arrow.left") {
                            onMoveLeft(work)
                        }
                    }
                    
                    if let onMoveRight = onMoveRight {
                        IconButton("arrow.right") {
                            onMoveRight(work)
                        }
                    }
                }
            }
            
            IconButton("square.and.pencil") {
                onEdit(work)
            }
            
            IconButton("trash") {
                onDelete(work)
            }
        }
    }
    
    private var needArrows: Bool {
        onMoveLeft != nil || onMoveRight != nil
    }
}

struct BookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        WorkView(work: .preview) { _ in
            
        } onDelete: { _ in
            
        }

        
    }
}
