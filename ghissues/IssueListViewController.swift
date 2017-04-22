//
//  IssuesViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit

class IssuesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var didSelectIssue: ((Issue) -> Void)?
    var issues = [Issue]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "issueCell")
        return tv
    }()
    
    static func defaultInstance(for repo: Repo) -> IssuesViewController {
        let issuesVC = IssuesViewController()
        
        GithubClient().fetchIssues(for: repo, completion: { (issues, error) in
            issuesVC.issues = issues ?? [Issue]()
        })
        
        return issuesVC
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
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath)
        cell.textLabel?.text = issues[indexPath.item].title
        return cell
    }
    
    //MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIssue?(issues[indexPath.item])
    }

}
