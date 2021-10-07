////
////  BookCoverPreview.swift
////  TinmeyMacOS
////
////  Created by Dmitry Borodin on 19.08.2021.
////
//
//import SwiftUI
//
//struct WorkPreview: View {
//    private let workPreview: Work
//    
//    init(workPreview: Work) {
//        self.workPreview = workPreview
//    }
//
//    var body: some View {
//        HStack(spacing: 4) {
//            AsyncImage(url: workPreview.imageURL) {
//                Image("book")
//            }
//            .frame(width: 40, height: 40)
//            .background(Color.gray)
//            .cornerRadius(4)
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text(workPreview.title)
//                    .fontWeight(.bold)
//                Text(workPreview.shortDescription)
//                    .font(.caption)
//            }
//            Spacer()
//        }
//    }
//}
//
//struct BookCoverPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkPreview(workPreview: .preview)
//            .frame(width: 200)
//    }
//}
