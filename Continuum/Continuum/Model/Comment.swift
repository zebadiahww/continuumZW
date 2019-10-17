//
//  Comment.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/17/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation
import CloudKit

struct CommentConstants {
  static let recordType = "Comment"
  static let textKey = "text"
  static let timestampKey = "timestamp"
  static let postReferenceKey = "post"
}


class Comment {
    
    var text: String
    var timeStamp: Date
    weak var post: Post?
    let recordID: CKRecord.ID
    var postReference: CKRecord.Reference? {
        guard let post = post else { return nil }
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timeStamp: Date = Date(), post: Post, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timeStamp = timeStamp
        self.post = post
        self.recordID = recordID
    }
    //this creates a comment from a ckrecord
    convenience init?(ckRecord: CKRecord, post: Post) {
        guard let text = ckRecord[CommentConstants.textKey] as? String,
            let timeStamp = ckRecord[CommentConstants.timestampKey] as? Date else { return nil }
        
        self.init(text: text, timeStamp: timeStamp, post: post, recordID: ckRecord.recordID)
    }
}

//this creates a ckrecord from a comment to send to the cloud
extension CKRecord {
     convenience init(comment: Comment) {
       self.init(recordType: CommentConstants.recordType, recordID: comment.recordID)
       self.setValue(comment.postReference, forKey: CommentConstants.postReferenceKey)
       self.setValue(comment.text, forKey: CommentConstants.textKey)
       self.setValue(comment.timeStamp, forKey: CommentConstants.timestampKey)
     }
}


extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return text.contains(searchTerm)
    }
}

