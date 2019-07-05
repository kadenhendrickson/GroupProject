//
//  ImagePickerHelper.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

/**
 Conform to this class to present preset UIImagePicker and create actions to handle data.
 
 ## Require:
    [fireActionsForSelectedImage()](x-source-tag://fireActionsForSelectedImage)
 
 ## Related:
    [ImagePickerHelper](x-source-tag://ImagePickerHelper).
 */
/// - Tag: ImagePickerHelperDelegate
protocol ImagePickerHelperDelegate {
    
    /**
     This function fire actions in the body after an image is selected from [ImagePickerHelper](x-source-tag://ImagePickerHelper).
     
     ## Implementation:
     Please declare this function's **body** when conforming to [ImagePickerHelperDelegate](x-source-tag://ImagePickerHelperDelegate).
     You can declare it with actions you want to happen after an image is selected from picker.
     
     ## Example:
     ```
     extension AddUserTableViewController: ImagePickerHelperDelegate {
     
        func fireActionsForSelectedImage(_ image: UIImage){
     
            selectedImageView.image = image
    
            guard let imageData = image.somethingData else { return }
            createNewUser(with: imageData)
            popView()
        }
     
     }
     ```
     
     - parameters:
         - image: a valid `UIImage` selected from the picker.
    */
    /// - Tag: fireActionsForSelectedImage
    func fireActionsForSelectedImage(_ image: UIImage)
    
}

/**
 Create an instance of this helper to access [presentImagePicker()](x-source-tag://presentImagePicker) method.
 
 ## Implementation:
 
 1. Declare an instance of this class at class level.
 
    ```
    let imagePickerHelper = ImagePickerHelper()
    ```
 
 2. In `viewDidLoad`, set the delegate for the helper.
 
    ```
    imagePickerHelper.delegate = self
    ```
 
 3. Call [presentImagePicker()](x-source-tag://presentImagePicker) method inside IBaction or use selector to add action.

     ```
     @IBAction func selectImageButtonTapped(_ sender: Any) {
         imagePickerHelper.presentImagePicker(for: self)
     }
     ```
 
 # Required:
 Conforming to [ImagePickerHelperDelegate](x-source-tag://ImagePickerHelperDelegate).
*/
/// - Tag: ImagePickerHelper
class ImagePickerHelper: UIViewController {
    
    var delegate: ImagePickerHelperDelegate?
    weak var controller: UIViewController?
    
    /// Present an action sheet to choose between library and camera, then present a `UIImagePicker`.
    /// - Tag: presentImagePicker
    @objc func presentImagePicker(for controller: UIViewController){
        /* Image Picker */
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.controller = controller
        
        /* Alert Controller */
        let alertController = UIAlertController(title: "Add new photo from ..", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // nothing
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let openCameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePickerController.sourceType = .camera
                controller.present(imagePickerController, animated: true, completion: nil)
            }
            alertController.addAction(openCameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let openLibraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
                imagePickerController.sourceType = .photoLibrary
                controller.present(imagePickerController, animated: true, completion: nil)
            }
            alertController.addAction(openLibraryAction)
        }
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true, completion: nil)
    }

    func dismissPicker(){
        self.controller?.dismiss(animated: true, completion: nil)
    }
}


extension ImagePickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage? = nil

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = editedImage
        } else if let libraryImage = info[.originalImage] as? UIImage {
            image = libraryImage
        }
        
        guard let selectedImage = image else {
            print("🍒 Cannot find an image selected or edited by user. Printing from \(#function) \n In \(String(describing: ImagePickerHelper.self)) 🍒"); return}
        
        guard let delegate = delegate else {
            print("🍒 Please extend your viewcontroller with ImagePickerHelper and conform to ImagePickerHelperDelegate. Printing from \(#function) \n In \(String(describing: ImagePickerHelperDelegate.self)) 🍒"); return}
        
        dismissPicker()
        
        // Set photoImageView to display the selected image.
        delegate.fireActionsForSelectedImage(selectedImage)
        
    }
}
