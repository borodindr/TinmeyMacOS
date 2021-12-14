//
//  TagView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 13.10.2021.
//

import SwiftUI

struct TagView: View {
    let name: String
    var onDelete: (() -> ())? = nil
    
    var body: some View {
        HStack {
            Text(name)
                .font(.caption)
                .fixedSize()
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(nsImage: NSImage(named: NSImage.stopProgressFreestandingTemplateName)!)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(Color.blue)
        .clipShape(Capsule())
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(name: "Tag name") {
            
        }
    }
}
