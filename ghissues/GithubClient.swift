//
//  GithubClient.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

protocol Resource {
    associatedtype ResourceParser: Parser

    var path: String { get }
}

struct GetCommentsResource: Resource {
    typealias ResourceParser = CommentParser

    let repo: Repo
    let issue: Issue

    var path: String {
        return "/repos/\(repo.fullName)/issues/\(issue.number)/comments"
    }
}

struct GetIssuesResource: Resource {
    typealias ResourceParser = IssueParser

    let repo: Repo

    var path: String {
        return "/repos/\(repo.fullName)/issues"
    }
}

struct GetReposResource: Resource {
    typealias ResourceParser = RepoParser

    let username: String

    var path: String {
        return "/users/\(username)/repos"
    }
}


class GithubClient {
    private let baseURL: URL

    static let `default` = GithubClient(baseURL: URL(string: "https://api.github.com")!)

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    enum ServiceError: Error {
        case invalid(String)
    }
    
    func fetchResource<R>(resource: R) -> Promise<[R.ResourceParser.T]> where R: Resource {
        return Promise { fulfill, reject in
            if let url = URL(string: resource.path, relativeTo: baseURL) {
                Alamofire.request(url).responseJSON { response in
                    if let json = response.result.value as? [[String: Any]] {
                        do {
                            let result = try json.map { dict in try R.ResourceParser.parse(dict: dict) }
                            fulfill(result)
                        } catch {
                            reject(error)
                        }
                    }
                }
            } else {
                reject(ServiceError.invalid("URL"))
            }
        }
    }
}
