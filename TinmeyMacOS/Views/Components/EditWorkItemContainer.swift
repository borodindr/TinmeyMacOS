//
//  EditWorkItemContainer.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditWorkItemContainer<Content, Controls>: View where Content: View, Controls: View {
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
            WorkItemContainer {
                content()
            }
            .overlayOnHover(overlay: controls)
        } else {
            WorkItemContainer {
                content()
            }
        }
    }
}

struct EditWorkItemContainer_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkItemContainer {
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
