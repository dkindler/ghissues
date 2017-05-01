//
//  AppDelegate.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let repoViewController = RepoListViewController.defaultInstance(for: "linkedin")
        let nav = UINavigationController(rootViewController: repoViewController)
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "search"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(didPressSearchButton))
        
        repoViewController.navigationItem.rightBarButtonItem = searchButton
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

        return true
    }
    
    // MARK: Private
    
    @objc private func didPressSearchButton() {
        
    }
}

