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
    var onMoveUp: ((Work) -> ())?
    var onMoveDown: ((Work) -> ())?
    var onEdit: (Work) -> ()
    var onDelete: (Work) -> ()
    
    var body: some View {
        HStack(spacing: 20) {
            content
            if AuthAPIService.isAuthorized {
                controls
            }
            Spacer()
        }
    }
    
    private var columns: Int {
        3
    }
    
    private var rows: Int {
        (work.items.count - 1) / columns + 1
    }
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            ForEach(work.twoDArray) { row in
                HStack(spacing: 0) {
                    ForEach(row) { item in
                        WorkItemView(work: work, item: item)
                    }
                }
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
