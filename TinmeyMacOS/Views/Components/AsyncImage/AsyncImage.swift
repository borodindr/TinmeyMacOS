//
//  AsyncImage.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 31.08.2021.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: (() -> Placeholder)?
    
    private static var defaultPlaceholder: some View {
        Image("no_image")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40) as! Placeholder
    }
    
    init(url: URL?, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.placeholder = placeholder
        loader = ImageLoader(url: url)
    }
    
    init(url: URL?) where Placeholder == Image {
        self.placeholder = nil
        loader = ImageLoader(url: url)
    }
    
    var body: some View {
        content
//            .onAppear {
//                loader.load()
//            }
    }
    
    var content: some View {
        Group {
            if let image = loader.image {
                Image(nsImage: image)
                    .resizable()
            } else {
                if let placeholder = placeholder {
                    placeholder()
                } else {
                    Image("no_image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
        }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        let url = APIURLBuilder.api()
            .path("works")
            .path("images")
            .path("EEDC3EB8-CE9E-4AE5-8D3B-03ADB2EDEEA0")
            .buildURL()
        return AsyncImage(url: url) {
            Image("no_image")
        }
    }
}
