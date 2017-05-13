//
//  RepoListViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit

class RepoListViewController: LayoutTableViewController{

    var didSelectRepo: ((Repo) -> Void) = { _ in }
    var didTapSearch: () -> () = {}
    
    var repos = [Repo]() {
        didSet {
            layouts = repos.map { r in
                RepoCellLayout(repoTitle: r.name, updated: r.updated, language: r.language, issueCount: r.openIssuesCount)
            }
        }
    }

    static func defaultInstance(for username: String) -> RepoListViewController {
        let repoVC = RepoListViewController()
        repoVC.title = "\(username)'s repos"
        
        GithubClient.default.fetchResource(resource: GetReposResource(username: username)).then { repos in
            repoVC.repos = repos
        }.catch { error in
            //TODO
        }
        
        repoVC.didSelectRepo = { (repo) in
            let issueVC = IssueListViewController.defaultInstance(for: repo)
            repoVC.show(issueVC, sender: repoVC)
        }
        
        repoVC.didTapSearch = {
            let alert = UIAlertController(title: "Enter a username", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            var textField: UITextField?
            alert.addTextField { (field) in
                textField = field
            }
            
            alert.addAction(
                UIAlertAction(title: "Go", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    let nav = UINavigationController(rootViewController: RepoListViewController.defaultInstance(for: textField?.text ?? ""))
                    repoVC.navigationController?.present(nav, animated: false, completion: nil)
                })
            )
            
            alert.addAction(
                UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                })
            )
            
            repoVC.navigationController?.present(alert, animated: true, completion: nil)
        }
        
        return repoVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "search"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.didPressSearchButton))
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    // MARK: Reloadable View Layout Adapter Delegate
    
    override func didSelectItemAt(indexPath: IndexPath) {
        didSelectRepo(repos[indexPath.item])
    }
    
    // MARK: Private
    
    @objc private func didPressSearchButton() {
        didTapSearch()
    }
}
