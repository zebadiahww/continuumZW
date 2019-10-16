//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/15/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {

        photoImageView.image = post?.photo
        captionLabel.text = post?.caption
        commentsCount.text = "\(post?.comments.count ?? 0)"
        
    }

}
