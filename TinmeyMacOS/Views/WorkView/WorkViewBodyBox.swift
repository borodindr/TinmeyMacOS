//
//  WorkViewBodyBox.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 04.10.2021.
//

import SwiftUI

struct WorkViewBodyBox: View {
    let title: String
    let description: String
    let onSeeWork: () -> ()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.system(size: 25))
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                Spacer()
                Button("See work") {
                    onSeeWork()
                }
                .font(.system(size: 13))
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 7)
                .padding(.vertical, 5)
                .background(Color.secondary)
                .cornerRadius(2.5)
            }
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 24)
        .padding(.bottom, 60)
        .frame(width: 300, height: 300)
    }
}

struct WorkViewBodyBox_Previews: PreviewProvider {
    static var previews: some View {
        let work = Work.preview
        WorkViewBodyBox(title: work.title, description: work.description) {
            print("See work")
        }
    }
}
