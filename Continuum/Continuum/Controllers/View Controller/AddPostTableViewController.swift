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
    @IBOutlet weak var captionTextField: UITextField!
    
    var selectedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captionTextField.text = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "toPhotoSelectorVC" {
        let photoSelector = segue.destination as? PhotoSelectorViewController
        photoSelector?.delegate = self
      }
    }
    
    // Actions
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let image = selectedImage,
            let caption = captionTextField.text else { return }
        PostController.shared.createPostWith(image: image, caption: caption) { (post) in
            
        }
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        
    }
}
extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}
