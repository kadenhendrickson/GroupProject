//
//  ImagePickerHelper.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol ImagePickerHelperDelegate {
    func updateImageView(withImage image: UIImage)
}

class ImagePickerHelper: UIViewController {
    
    var delegate: ImagePickerHelperDelegate?
    
    func presentImagePicker(toView view: UIView){
        /* Image Picker */
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        /* Alert Controller */
        let alertController = UIAlertController(title: "Add new photo from ..", message: nil, preferredStyle: .actionSheet)


        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // nothing
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let openCameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            alertController.addAction(openCameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let openLibraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
            alertController.addAction(openLibraryAction)
        }

        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }


}


extension ImagePickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        

        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        guard let delegate = delegate else {
            print("🍒 Please extend your viewcontroller with ImagePickerHelper and conform to ImagePickerHelperDelegate. Printing from \(#function) \n In \(String(describing: ImagePickerHelperDelegate.self)) 🍒"); return
        }
        
        // Set photoImageView to display the selected image.
        delegate.updateImageView(withImage: selectedImage)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
 
}
