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
    
    static let baseURL = "https://api.github.com"

    enum ServiceError: Error {
        case invalid(String)
    }
    
    case fetchComments(issue: Issue)
    case fetchIssues(repo: Repo)
    case fetchRepos(username: String)
    
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
                            try completion?(ObjectParser.comment.parse(dicts: JSON), nil)
                        case .fetchRepos(_):
                            try completion?(ObjectParser.repo.parse(dicts: JSON), nil)
                        case .fetchIssues(_):
                            try completion?(ObjectParser.issue.parse(dicts: JSON), nil)
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion?(nil, error)
                    }
                } else {
                    completion?(nil, ServiceError.invalid("Response"))
                }
            }
        } catch {
            print(error.localizedDescription)
            completion?(nil, error)
        }
    }
}
