//
//  User.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let avatar: URL?
    
    init(id: Int, username: String, avatar: URL? = nil) {
        self.id = id
        self.username = username
        self.avatar = avatar
    }
}
