//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/15/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
        
    // OUTLETS
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = post else { return }
        PostController.shared.fetchCommentsFor(post: post) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Actions
    @IBAction func commentButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Comment", message: "leave a comment", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "plz comment baby"
        }
        let canclAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let commentAction = UIAlertAction(title: "Comment", style: .default) { (_) in
            guard let commentText = alertController.textFields?.first?.text,  !commentText.isEmpty,
            let post = self.post else { return }
            PostController.shared.addComment(post: post, text: commentText) { (comment) in
            }
            self.tableView.reloadData()
        }
        alertController.addAction(canclAction)
        alertController.addAction(commentAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let caption = post?.caption else { return }
        let shareSheet = UIActivityViewController(activityItems: [caption], applicationActivities: nil)
        present(shareSheet, animated: true, completion: nil)
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
    }
    
    
    
    func updateViews() {
        photoImageView.image = post?.photo
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comments.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postDetailCell", for: indexPath)
        
        let comment = post?.comments[indexPath.row]
        cell.textLabel?.text = comment?.text
        cell.detailTextLabel?.text = comment?.timeStamp.formatDate()
        
        return cell
    }
    
}
