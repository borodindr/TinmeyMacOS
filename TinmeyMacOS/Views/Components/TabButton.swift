//
//  TabButton.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 20.08.2021.
//

import SwiftUI

struct TabButton: View {
    var section: AppSection
    @Binding var selectedSection: AppSection
    
    private var isSelected: Bool {
        selectedSection == section
    }
    
    var body: some View {
        Button(action: {
//            withAnimation {
                selectedSection = section
//            }
        }, label: {
            VStack(spacing: 7) {
                if let imageName = section.imageName,
                   let image = NSImage(named: imageName) {
                    Image(nsImage: image)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .gray)
                }
                
                Text(section.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(.vertical, 8)
            .frame(width: 100)
            .contentShape(Rectangle())
            .background(Color.primary.opacity(isSelected ? 0.15 : 0))
            .cornerRadius(10)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabButton_Previews: PreviewProvider {
    static let selectedSection = AppSection.home
    static var previews: some View {
        ForEach(AppSection.allCases, id: \.self) { section in
            TabButton(section: section, selectedSection: .constant(selectedSection))
            
        }
    }
}
