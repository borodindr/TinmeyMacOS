//
//  WorkViewLargeBodyBox.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 04.10.2021.
//

import SwiftUI

struct WorkViewLargeBodyBox: View {
    let title: String
    let description: String
    let tags: [String]
    var seeMoreLink: URL?
    
    var body: some View {
        HStack {
            WorkViewBodyBox(title: title, description: description, tags: tags, seeMoreLink: seeMoreLink)
            Spacer()
        }
        .frame(width: 600, height: 300)
    }
}

struct WorkViewLargeBodyBox_Previews: PreviewProvider {
    static var previews: some View {
        let work = Work.preview
        WorkViewLargeBodyBox(title: work.title, description: work.description, tags: work.tags, seeMoreLink: work.seeMoreLink)
    }
}
