//
//  WorkItemContainer.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 26.12.2021.
//

import SwiftUI

struct WorkItemContainer<Content: View>: View {
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    let content: Content
    
    var body: some View {
        content
            .frame(width: 300, height: 300)
            .border(Color.gray, width: 1)
            .background(Color.black)
    }
}

struct WorkItemContainer_Previews: PreviewProvider {
    static var previews: some View {
        WorkItemContainer {
            VStack {
                Text("A")
                Text("B")
            }
        }
    }
}
