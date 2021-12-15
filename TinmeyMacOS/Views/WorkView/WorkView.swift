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
    
    var body: some View {
        HStack(spacing: 20) {
            boxesForLayout
                .background(Color.black)
                .border(Color.gray, width: 1)
            controls
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
                                seeMoreLink: work.seeMoreLink)
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewImageBox(imageURL: work.secondImageURL)
            case .middleBody:
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewBodyBox(title: work.title,
                                description: work.description,
                                tags: work.tags,
                                seeMoreLink: work.seeMoreLink)
                WorkViewImageBox(imageURL: work.secondImageURL)
            case .rightBody:
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewImageBox(imageURL: work.secondImageURL)
                WorkViewBodyBox(title: work.title,
                                description: work.description,
                                tags: work.tags,
                                seeMoreLink: work.seeMoreLink)
            case .leftLargeBody:
                WorkViewLargeBodyBox(title: work.title,
                                     description: work.description,
                                     tags: work.tags,
                                     seeMoreLink: work.seeMoreLink)
                WorkViewImageBox(imageURL: work.firstImageURL)
            case .rightLargeBody:
                WorkViewImageBox(imageURL: work.firstImageURL)
                WorkViewLargeBodyBox(title: work.title,
                                     description: work.description,
                                     tags: work.tags,
                                     seeMoreLink: work.seeMoreLink)
            }
        }
    }
    
    private var controls: some View {
        HStack(spacing: 16) {
            if onMoveUp != nil || onMoveDown != nil {
                VStack(spacing: 16) {
                    if let onMoveUp = onMoveUp {
                        IconButton("arrow_up") {
                            onMoveUp(work)
                        }
                    }
                    
                    if let onMoveDown = onMoveDown {
                        IconButton("arrow_down") {
                            onMoveDown(work)
                        }
                    }
                }
            }
            
            IconButton("edit") {
                onEdit(work)
            }
            
            IconButton("trash") {
                onDelete(work)
            }
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
