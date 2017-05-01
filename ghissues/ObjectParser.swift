//
//  ObjectParser.swift
//  ghissues
//
//  Created by Dan Kindler on 4/22/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case missing(String)
    case invalid(String)
}

protocol Parser {
    associatedtype T

    static func parse(dict: [String: Any]) throws -> T
}

extension Parser {
    static func parse(dicts: [[String: Any]]) throws -> [T] {
        return try dicts.map(self.parse)
    }
}

class RepoParser: Parser {
    static func parse(dict: [String: Any]) throws -> Repo {
        guard let stringURL = dict["url"] as? String else { throw ParserError.missing("URL") }
        guard let stringIssuesURL = dict["issues_url"] as? String else { throw ParserError.missing("Issues URL") }
        guard let name = dict["name"] as? String else { throw ParserError.missing("Name") }
        guard let fullName = dict["full_name"] as? String else { throw ParserError.missing("Full Name") }
        guard let url = URL(string: stringURL) else { throw ParserError.invalid("URL String") }
        guard let id = dict["id"] as? Int else { throw ParserError.missing("ID") }
        guard let openIssuesCount = dict["open_issues_count"] as? Int else { throw ParserError.missing("Open Issues Count") }
        guard let language = dict["language"] as? String else { throw ParserError.missing("Language") }
        guard let updatedDateString = dict["updated_at"] as? String else { throw ParserError.missing("Updated Date String") }
        guard let updated = Date.from(string: updatedDateString) else { throw ParserError.invalid("Updated Date String") }

        // "issues_url" includes "{/number}" at the end of the URL. We must truncate this from the string.
        let endIndex = stringIssuesURL.index(stringIssuesURL.endIndex, offsetBy: -9)
        guard let issuesURL = URL(string: stringIssuesURL.substring(to: endIndex)) else { throw ParserError.invalid("Issues URL String") }

        return Repo(id: id,
                    name: name,
                    fullName: fullName,
                    url: url,
                    issuesURL: issuesURL,
                    updated: updated,
                    openIssuesCount: openIssuesCount,
                    language: language
        )
    }
}

class LabelParser: Parser {
    static func parse(dict: [String : Any]) throws -> Issue.Label {
        guard let name = dict["name"] as? String else { throw ParserError.missing("Issue Name") }
        guard let color = dict["color"] as? String else { throw ParserError.missing("Issue Color") }
        return Issue.Label(name: name, color: color)
    }
}

class IssueParser: Parser {
    static func parse(dict: [String : Any]) throws -> Issue {
        guard let title = dict["title"] as? String else { throw ParserError.missing("Title") }
        guard let body = dict["body"] as? String else { throw ParserError.missing("Body") }
        guard let commentsURLString = dict["comments_url"] as? String else { throw ParserError.missing("Comments URL") }
        guard let commentsURL = URL(string: commentsURLString) else { throw ParserError.invalid("Comments URL") }
        guard let userData = dict["user"] as? [String: Any] else { throw ParserError.missing("User") }
        guard let id = dict["id"] as? Int else { throw ParserError.missing("ID") }
        guard let number = dict["number"] as? Int else { throw ParserError.missing("number") }

        let labelsData = dict["labels"] as? [[String: Any]] ?? [[String: Any]]()
        let labels = try LabelParser.parse(dicts: labelsData)

        let user: User
        do {
            user = try UserParser.parse(dict: userData)
        } catch {
            throw ParserError.invalid("User")
        }

        return Issue(
            id: id,
            title: title,
            body: body,
            labels: labels,
            commentsURL: commentsURL,
            author: user,
            number: number
        )
    }
}

class CommentParser: Parser {
    static func parse(dict: [String : Any]) throws -> Comment {
        guard let id = dict["id"] as? Int else { throw ParserError.missing("id") }
        guard let body = dict["body"] as? String else { throw ParserError.missing("Body") }
        guard let userData = dict["user"] as? [String: Any] else { throw ParserError.missing("User") }

        let user: User
        do {
            user = try UserParser.parse(dict: userData)
        } catch {
            throw ParserError.invalid("User")
        }

        return Comment(id: id, body: body, author: user)
    }
}

class UserParser: Parser {
    static func parse(dict: [String : Any]) throws -> User {
        guard let username = dict["login"] as? String else { throw ParserError.missing("Username") }
        guard let id = dict["id"] as? Int else { throw ParserError.missing("ID") }

        let avatarUrl: URL?
        if let urlString = dict["avatar_url"] as? String {
            avatarUrl = URL(string: urlString)
        } else {
            avatarUrl = nil
        }

        return User(id: id, username: username, avatar: avatarUrl)
    }
}
