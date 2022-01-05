//
//  EditWorkClearItemView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 28.12.2021.
//

import SwiftUI

struct EditWorkItemClearView: View {
    var onSelectedImage: (URL) -> ()
    
    var body: some View {
        EditWorkItemContainer {
            Spacer()
        } controls: {
            Button(action: selectImage) {
                Text("Select image")
            }
        }
    }
    
    private func selectImage() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url {
            onSelectedImage(url)
        }
    }
}

struct EditWorkItemClearView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkItemClearView { url in
            
        }
    }
}
