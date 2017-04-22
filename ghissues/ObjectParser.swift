//
//  ObjectParser.swift
//  ghissues
//
//  Created by Dan Kindler on 4/22/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

enum ObjectParser {
    case issue
    case repo
    case user
    case comment
    case label
    
    enum ObjectParserError: Error {
        case missing(String)
        case invalid(String)
    }
    
    func parse(dicts: [[String: Any]]) throws -> [Any] {
        var data = [Any]()
        for d in dicts {
            do {
                try data.append(self.parse(dict: d))
            } catch {
                throw error
            }
        }
        
        return data
    }
    
    func parse(dict: [String: Any]) throws -> Any {
        do {
            switch self {
            case .comment:
                return try self.parseComment(dict: dict)
            case .issue:
                return try self.parseIssue(dict: dict)
            case .label:
                return try self.parseLabel(dict: dict)
            case .repo:
                return try self.parseRepo(dict: dict)
            case .user:
                return try self.parseUser(dict: dict)
            }
        } catch {
            throw error
        }
    }
    
    private func parseRepo(dict: [String: Any]) throws -> Repo {
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
    
    private func parseLabel(dict: [String: Any]) throws -> Issue.Label {
        guard let name = dict["name"] as? String else { throw ObjectParserError.missing("Issue Name") }
        guard let color = dict["color"] as? String else { throw ObjectParserError.missing("Issue Color") }
        return Issue.Label(name: name, color: color)
    }

    private func parseIssue(dict: [String: Any]) throws -> Issue {
        guard let title = dict["title"] as? String else { throw ObjectParserError.missing("Title") }
        guard let body = dict["body"] as? String else { throw ObjectParserError.missing("Body") }
        guard let commentsURLString = dict["comments_url"] as? String else { throw ObjectParserError.missing("Comments URL") }
        guard let commentsURL = URL(string: commentsURLString) else { throw ObjectParserError.invalid("Comments URL") }
        guard let userData = dict["user"] as? [String: Any] else { throw ObjectParserError.missing("User") }
        guard let id = dict["id"] as? Int else { throw ObjectParserError.missing("ID") }
        
        let labelsData = dict["labels"] as? [[String: Any]] ?? [[String: Any]]()
        
        let user: User?
        do {
            user = try ObjectParser.user.parse(dict: userData) as? User
        } catch {
            throw ObjectParserError.invalid("User")
        }
        
        typealias Label = Issue.Label
        var labels = [Label]()
        for l in labelsData {
            let label = try ObjectParser.label.parse(dict: l) as? Label
            if let label = label {
                labels.append(label)
            } else {
                throw ObjectParserError.invalid("Label")
            }
        }
        
        if let user = user {
            return Issue(id: id, title: title, body: body, labels: labels, commentsURL: commentsURL, author: user)
        } else {
            throw ObjectParserError.invalid("User")
        }
    }
    
    private func parseComment(dict: [String: Any]) throws -> Comment {
        guard let id = dict["id"] as? Int else { throw ObjectParserError.missing("id") }
        guard let body = dict["body"] as? String else { throw ObjectParserError.missing("Body") }
        guard let userData = dict["user"] as? [String: Any] else { throw ObjectParserError.missing("User") }
        
        let user: User?
        do {
            user = try ObjectParser.user.parse(dict: userData) as? User
        } catch {
            throw ObjectParserError.invalid("User")
        }
        
        if let user = user {
            return Comment(id: id, body: body, author: user)
        } else {
            throw ObjectParserError.invalid("User")
        }
    }
    
    private func parseUser(dict: [String: Any]) throws -> User {
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
