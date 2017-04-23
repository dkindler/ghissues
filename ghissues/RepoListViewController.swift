//
//  RepoListViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit

class RepoListDataSource: NSObject, UITableViewDataSource {
    let repos: [Repo]
    static let reuseIdentifier = "repoCell"

    init(repos: [Repo]) {
        self.repos = repos
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoListDataSource.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = repos[indexPath.item].name
        return cell
    }
}

class RepoListViewController: UIViewController, UITableViewDelegate {

    var didSelectRepo: ((Repo) -> Void)?
    var repos = [Repo]() {
        didSet {
            dataSource = RepoListDataSource(repos: repos)
            tableView.reloadData()
        }
    }

    var dataSource: RepoListDataSource? {
        didSet {
            tableView.dataSource = dataSource
        }
    }

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: RepoListDataSource.reuseIdentifier)
        return tv
    }()
    
    static func defaultInstance(for username: String) -> RepoListViewController {
        let repoVC = RepoListViewController()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    //MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRepo?(repos[indexPath.item])
    }
}
