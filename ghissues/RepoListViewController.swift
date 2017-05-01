//
//  RepoListViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit
import LayoutKit

class RepoListViewController: LayoutTableViewController{

    var didSelectRepo: ((Repo) -> Void)?
    var repos = [Repo]() {
        didSet {
            reloadTableView()
        }
    }

    static func defaultInstance(for username: String) -> RepoListViewController {
        let repoVC = RepoListViewController()
        repoVC.title = "\(username)'s repos"
        
        GithubClient.default.fetchResource(resource: GetReposResource(username: username)) { repos, error in
            //TODO: Handle Error
            guard let repos = repos else {
                repoVC.repos = [Repo]()
                return
            }
            
            repoVC.repos = repos
        }
        
        repoVC.didSelectRepo = { (repo) in
            let issueVC = IssueListViewController.defaultInstance(for: repo)
            repoVC.show(issueVC, sender: repoVC)
        }
        
        return repoVC
    }
    
    private func reloadTableView() {
        let layouts = repos.map { r in
            RepoCellLayout(repoTitle: r.name, updated: r.updated, language: r.language, issueCount: r.openIssuesCount)
        }
        
        reloadableViewLayoutAdapter.reload(width: self.tableView.frame.width, synchronous: true, layoutProvider: {
            [Section<[Layout]>(header: nil, items: layouts, footer: nil)]
        })
    }

    // MARK: Reloadable View Layout Adapter Delegate
    
    override func didSelectItemAt(indexPath: IndexPath) {
        didSelectRepo?(repos[indexPath.item])
    }

}
