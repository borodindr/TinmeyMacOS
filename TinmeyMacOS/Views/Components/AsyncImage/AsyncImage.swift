//
//  AsyncImage.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 31.08.2021.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder
    
    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
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
                placeholder
            }
        }
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImage(url: URL(string: "http://127.0.0.1:8080/api/works/images/EEDC3EB8-CE9E-4AE5-8D3B-03ADB2EDEEA0")!) {
            Image("house")
        }
    }
}