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
    var needSeeMoreLink: Bool
    let onMoveBackward: (() -> ())?
    let onMoveForward: (() -> ())?
    
    private var attributedTitle: Binding<NSAttributedString> {
        Binding<NSAttributedString> {
            NSAttributedString(string: title, attributes: [
                .font: NSFont.systemFont(ofSize: 25),
                .foregroundColor: NSColor.labelColor
            ])
        } set: { newValue in
            title = newValue.string
        }
    }
    
    private var attributedDescription: Binding<NSAttributedString> {
        Binding {
            NSAttributedString(string: description, attributes: [
                .font: NSFont.systemFont(ofSize: 15),
                .foregroundColor: NSColor.secondaryLabelColor
            ])
        } set: { newValue in
            description = newValue.string
        }
    }
    
    private var titlePlaceholder: NSAttributedString {
        placeholder("Title", font: .systemFont(ofSize: 25))
    }
    
    private var descriptionPlaceholder: NSAttributedString {
        placeholder("Description", font: .systemFont(ofSize: 15))
    }
    
    var body: some View {
        EditWorkItemContainer {
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    MultilineTextField(titlePlaceholder, text: attributedTitle, nsFont: .systemFont(ofSize: 25))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.secondary, lineWidth: 0.5)
                        )
                    MultilineTextField(descriptionPlaceholder, text: attributedDescription, nsFont: .systemFont(ofSize: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.secondary, lineWidth: 0.5))
                    Spacer()
                    TagsListView(tags: tags) { tagToDelete in
                        guard let indexToDelete = tags.firstIndex(of: tagToDelete) else {
                            return
                        }
                        tags.remove(at: indexToDelete)
                    }
                    
                    if needSeeMoreLink {
                        BoxLinkButton(text: "See work")
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
            tags: .constant(["tag"]),
            needSeeMoreLink: true) {
                
            } onMoveForward: {
                
            }
    }
}
