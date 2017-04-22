//
//  GithubClient.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import Foundation
import Alamofire

enum GithubClient {
    case fetchComments(issue: Issue)
    case fetchIssues(repo: Repo)
    case fetchRepos(username: String)
    
    static private let baseURL = "https://api.github.com"

    enum ServiceError: Error {
        case invalid(String)
    }
    
    func url() throws -> URL {
        let url: URL?
        switch self {
        case .fetchComments(let issue):
            url = issue.commentsURL
        case .fetchIssues(let repo):
            url = URL(string: "\(GithubClient.baseURL)/repos/\(repo.fullName)/issues")
        case .fetchRepos(let username):
            url = URL(string: "\(GithubClient.baseURL)/users/\(username)/repos")
        }
        
        if let url = url {
            return url
        } else {
            throw ServiceError.invalid("URL")
        }
    }
    
    func call(completion:(([Any]?, Error?) -> ())?) {
        do {
            let url = try self.url()
            Alamofire.request(url).responseJSON { (response) in
                if let JSON = response.result.value as? [[String: Any]] {
                    do {
                        switch self {
                        case .fetchComments(_):
                            try completion?(ObjectParser<Comment>.parse(dicts: JSON), nil)
                        case .fetchRepos(_):
                            try completion?(ObjectParser<Repo>.parse(dicts: JSON), nil)
                        case .fetchIssues(_):
                            try completion?(ObjectParser<Issue>.parse(dicts: JSON), nil)
                        }
                    } catch {
                        completion?(nil, error)
                    }
                } else {
                    completion?(nil, ServiceError.invalid("Response"))
                }
            }
        } catch {
            completion?(nil, error)
        }
    }
}
