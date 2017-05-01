//
//  LayoutTableViewController.swift
//  ghissues
//
//  Created by Dan Kindler on 5/1/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit
import LayoutKit

class LayoutTableViewController: UIViewController, CustomReloadableViewLayoutAdapterDelegate {

    var reloadableViewLayoutAdapter: CustomReloadableViewLayoutAdapter!
    var layouts: [InsetLayout<View>]?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        self.reloadableViewLayoutAdapter = CustomReloadableViewLayoutAdapter(reloadableView: tv)
        self.reloadableViewLayoutAdapter.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self.reloadableViewLayoutAdapter
        tv.delegate = self.reloadableViewLayoutAdapter
        tv.backgroundColor = .white
        tv.frame = self.view.bounds
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func reloadTableView() {
        reloadableViewLayoutAdapter.reload(width: self.tableView.frame.width, synchronous: true, layoutProvider: {
            [Section<[Layout]>(header: nil, items: self.layouts ?? [], footer: nil)]
        })
    }
    
    // MARK: Reloadable View Layout Adapter Delegate
    
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
