//
//  EditItemContainer.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditItemContainer<Content, Controls>: View where Content: View, Controls: View {
    let content: () -> Content
    let controls: () -> Controls
    
    init(
        @ViewBuilder
        _ content: @escaping () -> Content,
        @ViewBuilder
        controls: @escaping () -> Controls
    ) {
        self.content = content
        self.controls = controls
    }
    
    var body: some View {
        if AuthAPIService.isAuthorized {
            ItemContainer {
                content()
            }
            .overlayOnHover(overlay: controls)
        } else {
            ItemContainer {
                content()
            }
        }
    }
}

struct EditItemContainer_Previews: PreviewProvider {
    static var previews: some View {
        EditItemContainer {
            Text("A")
        } controls: {
            Button { } label: {
                Text("<")
            }
            
            Button { } label: {
                Text("button")
            }

            Button { } label: {
                Text(">")
            }
        }

    }
}
