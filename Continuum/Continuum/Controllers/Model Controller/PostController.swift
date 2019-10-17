//
//  PostController.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/15/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    // MARK: - shared instance
    static let shared = PostController()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - SoT
    var posts: [Post] = []
    
    //MARK: - CRUD
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let newPost = Post(caption: caption, photo: image)
        self.posts.append(newPost)
        let record = CKRecord(post: newPost) 
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let record = record,
                let post = Post(ckRecord: record) else { completion(nil) ; return }
            completion(post)
        }
    }
    
    func addComment(post: Post, text: String, completion: @escaping (Comment?) -> Void) {
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
        let record = CKRecord(comment: newComment)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            guard let record = record else { completion(nil); return }
            let comment = Comment(ckRecord: record, post: post)
//            self.incrementCommentCount(for:post, completion:nil)
            completion(comment)
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.typeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let records = foundRecords else {
                completion(nil); return }
            let posts = records.compactMap { Post(ckRecord: $0) }
            self.posts = posts
            print("fetched Posts")
            completion(posts)
            
        }
    }
    
    func fetchCommentsFor(post: Post, completion: @escaping ([Comment]?) -> Void) {
        let postRefence = post.recordID
        
        let predicate = NSPredicate(format: "%K == %@", CommentConstants.postReferenceKey, postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            let comments = records.compactMap{ Comment(ckRecord: $0, post: post) }
            post.comments.append(contentsOf: comments)
            completion(comments)
        }
    }
}


