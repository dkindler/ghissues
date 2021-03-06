//
//  Comment.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

struct Comment {
    let id: Int
    let author: User
    let body: String
    let createdAt: Date
    
    init(id: Int, body: String, author: User, createdAt: Date) {
        self.id = id
        self.body = body
        self.author = author
        self.createdAt = createdAt
    }
}
