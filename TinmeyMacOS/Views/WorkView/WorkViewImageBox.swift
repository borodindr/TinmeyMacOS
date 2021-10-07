//
//  WorkViewImageBox.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 04.10.2021.
//

import SwiftUI

struct WorkViewImageBox: View {
    let imageURL: URL?
    
    var body: some View {
        AsyncImage(url: imageURL) {
            Image("book")
        }
//        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 300, height: 300)
        
        .border(Color.gray, width: 1)
    }
}

struct WorkViewImageBox_Previews: PreviewProvider {
    static var previews: some View {
        WorkViewImageBox(imageURL: URL(string: "http://127.0.0.1:8080/api/works/28DBFA32-C19A-4B8F-AF7B-5C229B50D53E/secondImage"))
    }
}
