//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/15/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    // Outlet
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = nil
    }
    
    
    // Action
    @IBAction func selectImageButtonTapped(_ sender: Any) {
    }
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let image = selectedImage,
            let caption = captionTextField.text else { return }
        PostController.shared.createPostWith(image: image, caption: caption) { (_) in
            
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0

    }
    
    
    // MARK: - Table view data source



}
