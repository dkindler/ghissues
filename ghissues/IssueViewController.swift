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
    
    var issue: Issue?
    var comments = [Comment]() {
        didSet {
            layout()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
    }
    
    private func layout() {
        var layouts = [CommentCellLayout]()
        for c in comments {
            let data = CommentCellLayout.Data(username: c.author.username, avatar: c.author.avatar, commentBody: c.body)
            layouts.append(CommentCellLayout(data: data))
        }
        if let issue = issue {
            let body = issue.body == "" ? issue.title : issue.body
            let data = CommentCellLayout.Data(username: issue.author.username, avatar: issue.author.avatar, commentBody: body)
            layouts.insert(CommentCellLayout(data: data), at: 0)
        }

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
