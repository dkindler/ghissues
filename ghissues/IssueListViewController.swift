//
//  IssuesViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit

class IssueListViewController: LayoutTableViewController {

    var didSelectIssue: ((Issue) -> Void)?
    var issues = [Issue]() {
        didSet {
            layouts = issues.map { i in
                CommentCellLayout(username: i.author.username, avatar: i.author.avatar, commentBody: i.title)
            }
        }
    }
    
    static func defaultInstance(for repo: Repo) -> IssueListViewController {
        let issuesVC = IssueListViewController()
        issuesVC.title = repo.name

        GithubClient.default.fetchResource(resource: GetIssuesResource(repo: repo)).then { issues in
            issuesVC.issues = issues
        }.catch { error in
            //TODO: Throw error
        }

        issuesVC.didSelectIssue = { (issue) in
            let singleIssueVC = IssueViewController.defaultInstance(repo: repo, issue: issue)
            issuesVC.show(singleIssueVC, sender: issuesVC)
        }
        
        return issuesVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Table View Delegate
    
    override func didSelectItemAt(indexPath: IndexPath) {
        didSelectIssue?(issues[indexPath.item])
    }
}
