//
//  ObjectParser.swift
//  ghissues
//
//  Created by Dan Kindler on 4/22/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

struct ObjectParser<T> {

    enum ObjectParserError: Error {
        case missing(String)
        case invalid(String)
    }
    
    static func parse(dicts: [[String: Any]]) throws -> [T] {
        var data = [T]()
        for d in dicts {
            do {
                try data.append(self.parse(dict: d))
            } catch {
                throw error
            }
        }
        
        return data
    }
    
    static func parse(dict: [String: Any]) throws -> T {
        do {
            if T.self is Comment.Type {
               return try self.parseComment(dict: dict) as! T
            } else if T.self is Issue.Type {
                return try self.parseIssue(dict: dict) as! T
            } else if T.self is Issue.Label.Type {
                return try self.parseLabel(dict: dict) as! T
            } else if T.self is User.Type {
                return try self.parseUser(dict: dict) as! T
            } else if T.self is Repo.Type {
                return try self.parseRepo(dict: dict) as! T
            } else {
                throw ObjectParserError.invalid("Object Type")
            }
        } catch {
            throw error
        }
    }
    
    static private func parseRepo(dict: [String: Any]) throws -> Repo {
        guard let stringURL = dict["url"] as? String else { throw ObjectParserError.missing("URL") }
        guard let stringIssuesURL = dict["issues_url"] as? String else { throw ObjectParserError.missing("Issues URL") }
        guard let name = dict["name"] as? String else { throw ObjectParserError.missing("Name") }
        guard let fullName = dict["full_name"] as? String else { throw ObjectParserError.missing("Full Name") }
        guard let url = URL(string: stringURL) else { throw ObjectParserError.invalid("URL String") }
        guard let id = dict["id"] as? Int else { throw ObjectParserError.missing("ID") }
        
        // "issues_url" includes "{/number}" at the end of the URL. We must truncate this from the string.
        let endIndex = stringIssuesURL.index(stringIssuesURL.endIndex, offsetBy: -9)
        guard let issuesURL = URL(string: stringIssuesURL.substring(to: endIndex)) else { throw ObjectParserError.invalid("Issues URL String") }
        
        return Repo(id: id, name: name, fullName: fullName, url: url, issuesURL: issuesURL)
    }
    
    static private func parseLabel(dict: [String: Any]) throws -> Issue.Label {
        guard let name = dict["name"] as? String else { throw ObjectParserError.missing("Issue Name") }
        guard let color = dict["color"] as? String else { throw ObjectParserError.missing("Issue Color") }
        return Issue.Label(name: name, color: color)
    }

    static private func parseIssue(dict: [String: Any]) throws -> Issue {
        guard let title = dict["title"] as? String else { throw ObjectParserError.missing("Title") }
        guard let body = dict["body"] as? String else { throw ObjectParserError.missing("Body") }
        guard let commentsURLString = dict["comments_url"] as? String else { throw ObjectParserError.missing("Comments URL") }
        guard let commentsURL = URL(string: commentsURLString) else { throw ObjectParserError.invalid("Comments URL") }
        guard let userData = dict["user"] as? [String: Any] else { throw ObjectParserError.missing("User") }
        guard let id = dict["id"] as? Int else { throw ObjectParserError.missing("ID") }
        
        let labelsData = dict["labels"] as? [[String: Any]] ?? [[String: Any]]()
        
        let user: User
        do {
            user = try ObjectParser<User>.parse(dict: userData)
        } catch {
            throw ObjectParserError.invalid("User")
        }
        
        
        let labels = try ObjectParser<Issue.Label>.parse(dicts: labelsData)
        
        return Issue(id: id, title: title, body: body, labels: labels, commentsURL: commentsURL, author: user)
    }
    
    static private func parseComment(dict: [String: Any]) throws -> Comment {
        guard let id = dict["id"] as? Int else { throw ObjectParserError.missing("id") }
        guard let body = dict["body"] as? String else { throw ObjectParserError.missing("Body") }
        guard let userData = dict["user"] as? [String: Any] else { throw ObjectParserError.missing("User") }
        
        let user: User
        do {
            user = try ObjectParser<User>.parse(dict: userData)
        } catch {
            throw ObjectParserError.invalid("User")
        }
        
        return Comment(id: id, body: body, author: user)
    }
    
    static private func parseUser(dict: [String: Any]) throws -> User {
        guard let username = dict["login"] as? String else { throw ObjectParserError.missing("Username") }
        guard let id = dict["id"] as? Int else { throw ObjectParserError.missing("ID") }
        
        let avatarUrl: URL?
        if let urlString = dict["avatar_url"] as? String {
            avatarUrl = URL(string: urlString)
        } else {
            avatarUrl = nil
        }
        
        return User(id: id, username: username, avatar: avatarUrl)
    }
}
