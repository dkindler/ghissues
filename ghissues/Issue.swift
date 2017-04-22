//
//  Issue.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

struct Issue {
    public struct Label {
        let name: String
        let colorString: String
        
        init(name: String, color: String) {
            self.name = name
            self.colorString = color
        }
    }
    
    let id: Int
    let title: String
    let body: String
    let labels: [Label]
    let commentsURL: URL
    let author: User
    
    init(id: Int, title: String, body: String, labels: [Label], commentsURL: URL , author: User) {
        self.id = id
        self.title = title
        self.body = body
        self.labels = labels
        self.commentsURL = commentsURL
        self.author = author
    }
}
