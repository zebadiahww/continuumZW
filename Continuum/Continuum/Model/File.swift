//
//  File.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/15/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    var photoData: Data?
    var timeStamp: Date
    var caption: String
    var comments: [Comment]
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set { photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(caption: String, photo: UIImage, timeStamp: Date = Date(), comments: [Comment] = []) {
        self.caption = caption
        self.timeStamp = timeStamp
        self.comments = comments
        self.photo = photo
    }
}

class Comment {
    var text: String
    var timeStamp: Date
    weak var post: Post?
    
    init(text: String, timeStamp: Date = Date(), post: Post) {
        self.text = text
        self.timeStamp = timeStamp
        self.post = post
    }
    
}
