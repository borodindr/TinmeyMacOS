//
//  WorkItemImageView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 26.12.2021.
//

import SwiftUI

struct WorkItemImageView: View {
    let imageURL: URL?
    
    var body: some View {
        WorkItemContainer {
            AsyncImage(url: imageURL, content: { image in
                image.resizable()
            }, placeholder: {
                Image("no_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            })
            .aspectRatio(contentMode: .fit)
        }
    }
}

struct WorkItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        WorkItemImageView(imageURL: nil)
    }
}
