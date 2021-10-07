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
    let onSeeWork: () -> ()
    
    var body: some View {
        HStack {
            WorkViewBodyBox(title: title, description: description, onSeeWork: onSeeWork)
            Spacer()
        }
        .frame(width: 600, height: 300)
    }
}

struct WorkViewLargeBodyBox_Previews: PreviewProvider {
    static var previews: some View {
        let work = Work.preview
        WorkViewLargeBodyBox(title: work.title, description: work.description) {
            print("See work")
        }
    }
}
