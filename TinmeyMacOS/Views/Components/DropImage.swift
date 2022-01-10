//
//  DropImage.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 10.01.2022.
//

import SwiftUI

struct DropImage: View {
    var image: NSImage?
    @Binding var droppedImageURL: URL?
    @State private var isDropAllowed: Bool? = nil
    
    init(_ image: NSImage? = nil, droppedImageURL: Binding<URL?>) {
        self.image = image
        self._droppedImageURL = droppedImageURL
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .border(border, width: 3)
        .onDrop(of: [kUTTypeFileURL,
                      kUTTypeData]
                         .map { $0 as String },
                delegate: self)
    }
    
    private var border: some ShapeStyle {
        guard let isDropAllowed = isDropAllowed else {
            return Color.clear
        }
        return isDropAllowed ? Color.green : .red
    }
}

extension DropImage: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        info.loadFileURL { result in
            switch result {
            case .failure(let error):
                print("Error drop file:", error)
            case .success(let url):
                guard url.isImage() else { return }
                droppedImageURL = url
            }
        }
        
    }
    
    func dropEntered(info: DropInfo) {
        info.loadFileURL { result in
            guard case let .success(url) = result else { return }
            isDropAllowed = url.isImage()
        }
    }
    
    func dropExited(info: DropInfo) {
        isDropAllowed = nil
    }
}

struct DropImage_Previews: PreviewProvider {
    static var previews: some View {
        DropImage(droppedImageURL: .constant(nil))
    }
}
