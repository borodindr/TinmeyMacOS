//
//  WorkItemBodyView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 26.12.2021.
//

import SwiftUI

struct WorkItemBodyView: View {
    let title: String
    let description: String
    let tags: [String]
    let seeMoreLink: URL?
    
    init(work: Work) {
        self.title = work.title
        self.description = work.description
        self.tags = work.tags
        self.seeMoreLink = work.seeMoreLink
    }
    
    var body: some View {
        WorkItemContainer {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.system(size: 25))
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .layoutPriority(10)
                Spacer(minLength: 0)
                TagsListView(tags: tags)
                if let link = seeMoreLink {
                    Button("See work") {
                        NSWorkspace.shared.open(link)
                    }
                    .font(.system(size: 13))
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 7)
                    .padding(.vertical, 5)
                    .background(Color.secondary)
                    .cornerRadius(2.5)
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
        }
    }
}

struct WorkItemBodyView_Previews: PreviewProvider {
    static var previews: some View {
        WorkItemBodyView(work: .preview)
    }
}
