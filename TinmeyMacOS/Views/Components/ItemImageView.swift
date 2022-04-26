//
//  ItemImageView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 26.12.2021.
//

import SwiftUI
import URLImage

struct ItemImageView: View {
    let imageURL: URL?
    
    var body: some View {
        ItemContainer {
            if let imageURL = imageURL {
                URLImage(imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            } else {
                placeholder
            }
        }
    }
    
    private var placeholder: some View {
        Image("no_image")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
    }
}

struct ItemImageView_Previews: PreviewProvider {
    static var previews: some View {
        ItemImageView(imageURL: nil)
    }
}
