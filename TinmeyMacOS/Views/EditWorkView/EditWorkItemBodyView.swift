//
//  EditWorkBodyItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditWorkItemBodyView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var tags: [String]
    let onMoveBackward: (() -> ())?
    let onMoveForward: (() -> ())?
    
    var body: some View {
        EditWorkItemContainer {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    TextView(text: $title)
                        .placeholder("Title")
                        .backgroundColor(.clear)
                        .textColor(.labelColor)
                        .font(.systemFont(ofSize: 25))
                    
                    TextView(text: $description)
                        .placeholder("Description")
                        .backgroundColor(.clear)
                        .textColor(.secondaryLabelColor)
                        .font(.systemFont(ofSize: 15))
                    Spacer()
                    TagsListView(tags: tags) { tagToDelete in
                        guard let indexToDelete = tags.firstIndex(of: tagToDelete) else {
                            return
                        }
                        tags.remove(at: indexToDelete)
                    }
                }
                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
            .frame(width: 300, height: 300)
        } controls: {
            if let onMoveBackward = onMoveBackward {
                IconButton("arrow_left",
                           action: onMoveBackward)
            }
            
            if let onMoveForward = onMoveForward {
                IconButton("arrow_right",
                           action: onMoveForward)
            }
        }

    }
    
    private func placeholder(_ text: String, font: NSFont) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: NSColor.secondaryLabelColor
        ])
    }
    
    private func attributedText(_ text: String, font: NSFont) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: NSColor.labelColor
        ])
    }
}

struct EditWorkItemBodyView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkItemBodyView(
            title: .constant("Title"),
            description: .constant("Description"),
            tags: .constant(["tag"])) {
                
            } onMoveForward: {
                
            }
    }
}
