//
//  IssueViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit
import LayoutKit

class IssueViewController: LayoutTableViewController {

    var repo: Repo?
    var issue: Issue?
    var comments = [Comment]() {
        didSet {
            guard let issue = issue else { return }
            
            let issueLayout = CommentCellLayout(
                username: issue.author.username,
                avatar: issue.author.avatar,
                commentBody: issue.body.isEmpty ? issue.title : issue.body
            )
            let commentLayouts = comments.map { c in
                CommentCellLayout(username: c.author.username, avatar: c.author.avatar, commentBody: c.body)
            }
            
            layouts = [issueLayout] + commentLayouts
        }
    }
    
    static func defaultInstance(repo: Repo, issue: Issue) -> IssueViewController {
        let vc = IssueViewController()
        vc.title = issue.title
        vc.issue = issue
        
        GithubClient.default.fetchResource(resource: GetCommentsResource(repo: repo, issue: issue)).then { comments in
            vc.comments = comments
        }.catch { error in
            //TODO
        }
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    //MARK: Reloadable View Delegate

    override func didSelectItemAt(indexPath: IndexPath) {
        
    }
}

