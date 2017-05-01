//
//  RepoCellLayout.swift
//  ghissues
//
//  Created by Dan Kindler on 5/1/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit
import LayoutKit
import AFDateHelper

class RepoCellLayout: InsetLayout<View> {
    
    let repoTitle: String
    let updated: Date
    let language: String
    let issueCount: Int
    
    init(repoTitle: String, updated: Date, language: String, issueCount: Int) {
        self.repoTitle = repoTitle
        self.updated = updated
        self.language = language
        self.issueCount = issueCount
        
        
        let title = LabelLayout(
            text: repoTitle,
            font: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium),
            numberOfLines: 1,
            config: nil
        )
        
        let openIssuesString = issueCount == 1 ? "OPEN ISSUE" : "OPEN ISSUES"
        let issues = LabelLayout(
            text: "\(issueCount) \(openIssuesString)",
            font: UIFont.systemFont(ofSize: 12),
            numberOfLines: 1,
            config: nil
        )
        
        let date = LabelLayout(
            text: updated.toStringWithRelativeTime().capitalized,
            font: UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight),
            numberOfLines: 1,
            config: nil
        )
        
        let lang = LabelLayout(
            text: language,
            font: UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight),
            numberOfLines: 1,
            alignment: Alignment.centerTrailing,
            config: nil
        )
        
        let left = StackLayout(
            axis: .vertical,
            spacing: 2,
            alignment: Alignment.centerLeading,
            sublayouts: [title, issues]
        )
     
        let right = StackLayout(
            axis: .vertical,
            spacing: 2,
            alignment: Alignment.centerTrailing,
            sublayouts: [date, lang]
        )
        
        super.init(
            insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
            sublayout: StackLayout(
                axis: .horizontal,
                sublayouts: [
                    left, right
                ]
            ),
            config: { view in
                view.backgroundColor = UIColor.white
            }
        )
    }
}
