//
//  CommentCellLayout.swift
//  ghissues
//
//  Created by Dan Kindler on 4/20/17.
//  Copyright © 2017 Daniel Kindler. All rights reserved.
//

import UIKit
import LayoutKit
import AlamofireImage

class CommentCellLayout: InsetLayout<View> {
    
    struct Data {
        let username: String
        let avatar: URL?
        let commentBody: String
        
        init(username: String, avatar: URL?, commentBody: String) {
            self.commentBody = commentBody
            self.avatar = avatar
            self.username = username
        }
    }
    
    public init(data: CommentCellLayout.Data) {
        
        let profileImage = SizeLayout<UIImageView>(
            size: CGSize(width: 40, height: 40),
            alignment: Alignment.topCenter,
            config: { imageView in
                imageView.backgroundColor = .gray
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 40/2
                imageView.layer.masksToBounds = true
                if let url = data.avatar {
                    imageView.af_setImage(withURL: url)
                }
            }
        )
        
        let name = LabelLayout(
            text: data.username,
            font: .boldSystemFont(ofSize: CGFloat(14.0)),
            numberOfLines: 1,
            alignment: Alignment.topLeading,
            config: nil
        )
        
        
        let body = LabelLayout(
            text: data.commentBody,
            font: .systemFont(ofSize: CGFloat(16.0), weight: UIFontWeightLight),
            alignment: Alignment.topLeading,
            config: nil
        )
        
        let right = StackLayout(
            axis: .vertical,
            spacing: 2,
            alignment: Alignment.topLeading,
            sublayouts: [name, body]
        )

        
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 12,
                sublayouts: [
                    profileImage, right
                ]
            ),
            config: { view in
                view.backgroundColor = UIColor.white
            }
        )
    }
}
