//
//  Repo.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

struct Repo {
    let id: Int
    let name: String
    let fullName: String
    let url: URL
    let issuesURL: URL
    let openIssuesCount: Int
    let updated: Date
    let language: String
    
    
    init(id: Int, name: String, fullName: String, url: URL, issuesURL: URL, updated: Date, openIssuesCount: Int, language: String) {
        self.id = id
        self.name = name
        self.url = url
        self.issuesURL = issuesURL
        self.fullName = fullName
        self.openIssuesCount = openIssuesCount
        self.updated = updated
        self.language = language
    }
}
