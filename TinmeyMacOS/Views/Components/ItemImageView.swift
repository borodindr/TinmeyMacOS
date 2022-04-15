//
//  ItemImageView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 26.12.2021.
//

import SwiftUI

struct ItemImageView: View {
    let imageURL: URL?
    
    var body: some View {
        ItemContainer {
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

struct ItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        ItemImageView(imageURL: nil)
    }
}
