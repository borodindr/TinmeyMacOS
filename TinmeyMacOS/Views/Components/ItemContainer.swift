//
//  ItemContainer.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 26.12.2021.
//

import SwiftUI

struct ItemContainer<Content: View>: View {
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    let content: Content
    
    var body: some View {
        content
            .frame(width: 300, height: 300)
    }
}

struct ItemContainer_Previews: PreviewProvider {
    static var previews: some View {
        ItemContainer {
            VStack {
                Text("A")
                Text("B")
            }
        }
    }
}
