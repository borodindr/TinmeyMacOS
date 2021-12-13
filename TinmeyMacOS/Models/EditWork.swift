//
//  EditWork.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 11.12.2021.
//

import Foundation

struct EditWork: Identifiable {
    let id: UUID?
    let type: Work.WorkType
    var title: String
    var description: String
    var layout: Work.LayoutType
    var seeMoreLink: String
    var tags: [String]
    var newFirstImagePath: URL? = nil
    var currentFirstImagePath: URL? {
        guard let idString = id?.uuidString else { return nil }
        return APIURLBuilder.api()
            .path("works")
            .path(idString).path("firstImage").buildURL()
    }
    var newSecondImagePath: URL? = nil
    var currentSecondImagePath: URL? {
        guard let idString = id?.uuidString else { return nil }
        return APIURLBuilder.api()
            .path("works")
            .path(idString).path("secondImage").buildURL()
    }
    
    init(work: Work, type: Work.WorkType) {
        self.id = work.id
        self.type = type
        self.title = work.title
        self.description = work.description
        self.layout = work.layout
        self.seeMoreLink = work.seeMoreLink?.absoluteString ?? ""
        self.tags = work.tags
    }
    
    init(type: Work.WorkType) {
        self.id = nil
        self.type = type
        self.title = ""
        self.description = ""
        self.layout = .leftBody
        self.seeMoreLink = ""
        self.tags = []
    }
}
