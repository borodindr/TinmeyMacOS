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
            selectedSection = section
        }, label: {
            VStack(spacing: 7) {
                Image(section.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .white : .gray)
                
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
    static let selectedSection = AppSection.works
    static var previews: some View {
        ForEach(AppSection.allCases, id: \.self) { section in
            TabButton(section: section, selectedSection: .constant(selectedSection))
            
        }
    }
}
