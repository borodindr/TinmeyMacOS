//
//  BookCoverView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI

struct WorkView: View {
    var work: Work
    var onMoveUp: ((Work) -> ())?
    var onMoveDown: ((Work) -> ())?
    var onEdit: (Work) -> ()
    var onDelete: (Work) -> ()
    
    @State private var showControls = false
    
    var body: some View {
        HStack(spacing: 20) {
            boxesForLayout
                .background(Color.black)
                .border(Color.gray, width: 1)
            if showControls {
                controls
            }
        }
        .onHover { isHovering in
            withAnimation {
                showControls = isHovering
            }
        }
    }
    
    @ViewBuilder
    private var boxesForLayout: some View {
        HStack(spacing: 0) {
            switch work.layout {
            case .leftBody:
                WorkViewBodyBox(title: work.title,
                                description: work.description,
                                tags: work.tags,
                                onSeeWork: onSeeWork)
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewImageBox(imageURL: work.secondImageURL)
            case .middleBody:
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewBodyBox(title: work.title,
                                description: work.description,
                                tags: work.tags,
                                onSeeWork: onSeeWork)
                WorkViewImageBox(imageURL: work.secondImageURL)
            case .rightBody:
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewImageBox(imageURL: work.secondImageURL)
                WorkViewBodyBox(title: work.title,
                                description: work.description,
                                tags: work.tags,
                                onSeeWork: onSeeWork)
            case .leftLargeBody:
                WorkViewLargeBodyBox(title: work.title,
                                     description: work.description,
                                     tags: work.tags,
                                     onSeeWork: onSeeWork)
                WorkViewImageBox(imageURL: work.firstImageURL)
            case .rightLargeBody:
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewLargeBodyBox(title: work.title,
                                description: work.description,
                                     tags: work.tags,
                                onSeeWork: onSeeWork)
            }
        }
    }
    
    private var controls: some View {
        HStack {
            VStack {
                if let onMoveUp = onMoveUp {
                    Button {
                        onMoveUp(work)
                    } label: {
                        Image(nsImage: NSImage(named: NSImage.touchBarGoUpTemplateName)!)
                    }
                }
                
                if let onMoveDown = onMoveDown {
                    Button {
                        onMoveDown(work)
                    } label: {
                        Image(nsImage: NSImage(named: NSImage.touchBarGoDownTemplateName)!)
                    }
                }
            }
            
            Button {
                onEdit(work)
            } label: {
                Image(nsImage: NSImage(named: NSImage.touchBarComposeTemplateName)!)
            }
            
            Button {
                onDelete(work)
            } label: {
                Image(nsImage: NSImage(named: NSImage.touchBarDeleteTemplateName)!)
            }
        }
    }
    
    private func onSeeWork() {
        if let url = work.seeMoreLink {
            NSWorkspace.shared.open(url)
        }
    }
}

struct BookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        WorkView(work: .preview) { _ in
            
        } onDelete: { _ in
            
        }

        
    }
}
