//
//  RepoListViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit

class RepoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var didSelectRepo: ((Repo) -> Void)?
    var repos = [Repo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "repoCell")
        return tv
    }()
    
    static func defaultInstance(for username: String) -> RepoListViewController {
        let repoVC = RepoListViewController()
        
        GithubClient.fetchRepos(username: username).call { (repos, error) in
            //TODO: Handle Error
            guard let repos = repos as? [Repo] else {
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

    //MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        cell.textLabel?.text = repos[indexPath.item].name
        return cell
    }
    
    //MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRepo?(repos[indexPath.item])
    }
}


















