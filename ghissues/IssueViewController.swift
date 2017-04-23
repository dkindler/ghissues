//
//  IssueViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit
import LayoutKit

class IssueViewController: UIViewController, CustomReloadableViewLayoutAdapterDelegate {

    private var reloadableViewLayoutAdapter: CustomReloadableViewLayoutAdapter!

    var repo: Repo?
    var issue: Issue?
    var comments = [Comment]() {
        didSet {
            reloadTableView()
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.frame)
        self.reloadableViewLayoutAdapter = CustomReloadableViewLayoutAdapter(reloadableView: tv)
        self.reloadableViewLayoutAdapter.delegate = self
        tv.allowsSelection = false
        tv.separatorStyle = .none
        tv.dataSource = self.reloadableViewLayoutAdapter
        tv.delegate = self.reloadableViewLayoutAdapter
        tv.backgroundColor = .white
        tv.frame = self.view.bounds
        return tv
    }()
    
    static func defaultInstance(repo: Repo, issue: Issue) -> IssueViewController {
        let vc = IssueViewController()
        vc.title = issue.title
        vc.issue = issue

        GithubClient.default.fetchResource(resource: GetCommentsResource(repo: repo, issue: issue)) { comments, error in
            //TODO: Handle Error
            guard let comments = comments else {
                vc.comments = [Comment]()
                return
            }
            
            vc.comments = comments
        }
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    private func reloadTableView() {
        guard let issue = issue else { return }

        let issueLayout = CommentCellLayout(
            username: issue.author.username,
            avatar: issue.author.avatar,
            commentBody: issue.body.isEmpty ? issue.title : issue.body
        )
        let commentLayouts = comments.map { c in CommentCellLayout(username: c.author.username, avatar: c.author.avatar, commentBody: c.body) }

        let layouts = [issueLayout] + commentLayouts

        reloadableViewLayoutAdapter.reload(width: self.tableView.frame.width, synchronous: true, layoutProvider: {
            [Section<[Layout]>(header: nil, items: layouts, footer: nil)]
        })
    }
    
    //MARK: Reloadable View Delegate

    func didSelectItemAt(indexPath: IndexPath) {
        
    }
}

//MARK: CustomReloadableViewLayoutAdapter and Delegate

protocol CustomReloadableViewLayoutAdapterDelegate: class {
    func didSelectItemAt(indexPath: IndexPath)
}

class CustomReloadableViewLayoutAdapter: ReloadableViewLayoutAdapter {
    weak var delegate: CustomReloadableViewLayoutAdapterDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(indexPath: indexPath)
    }
}
