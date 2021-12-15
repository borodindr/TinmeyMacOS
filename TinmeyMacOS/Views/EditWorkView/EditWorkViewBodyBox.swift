//
//  EditWorkViewBodyBox.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 05.10.2021.
//

import SwiftUI
import WrappingHStack

struct EditWorkViewBodyBox: View {
    @Binding var title: String
    @Binding var description: String
    var tags: [String] = []
    var needSeeMoreLink: Bool
    var onTagDelete: (String) -> ()
    
//    init(title: Binding<String>, description: Binding<String>) {
//        self._title = title
//        self._description = description
//    }
    
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
                TagsListView(tags: tags, onDelete: onTagDelete)
                
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

struct EditWorkViewBodyBox_Previews: PreviewProvider {
    static var previews: some View {
        let work = Work.preview
        EditWorkViewBodyBox(
            title: .constant(work.title),
            description: .constant(work.description),
            needSeeMoreLink: work.seeMoreLink != nil) { _ in
                
            }
    }
}
