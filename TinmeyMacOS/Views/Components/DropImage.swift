//
//  DropImage.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 10.01.2022.
//

import SwiftUI

struct DropImage: View {
    @Binding var droppedImageURL: URL?
    @State private var isDropAllowed: Bool? = nil
    
    init(droppedImageURL: Binding<URL?>) {
        self._droppedImageURL = droppedImageURL
    }
    
    var body: some View {
        Group {
            AsyncImage(url: droppedImageURL, content: { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure, .empty:
                    Spacer()
                @unknown default:
                    fatalError()
                }
            })
        }
        .frame(minWidth: 0, maxWidth: .infinity,
               minHeight: 0, maxHeight: .infinity)
        .border(border, width: 3)
        .onDrop(of: [.fileURL, .data], delegate: self)
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
