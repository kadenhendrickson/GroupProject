//
//  EditProfileViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: Properties
    var currentUser: User?
    var imagePicker = ImagePickerHelper()
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountTextLabel: UILabel!
    
    let defaultPlaceholderText: String = "Something about yourself ..."

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentUserLandingPad()
        
        //delegate for disabling textfields
        imagePicker.delegate = self
        displayNameTextField.delegate = self
        bioTextView.delegate = self
        
        displayNameTextField.tag = 0
        bioTextView.tag = 1
        
        updateViews()
    }
    
    @IBAction func userSwipedView(_ sender: Any) {
        resignAllTextFields()
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        resignAllTextFields()
    }
    
    @IBAction func changeImageButtonTapped(_ sender: Any) {
        imagePicker.presentImagePicker(for: self)
    }
    
    @IBAction func deleteProfileButtonTapped(_ sender: Any) {
        deleteUser()
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: Any) {
        guard let currentUser = currentUser else { return }
        
        guard let displayName = displayNameTextField.text else { return }

        let image = profileImageView.image ?? UIImage(named: "duck")
        
        var bioText = bioTextView.text ?? ""
        
        // Provide blank defualt text if user left placeholder text in there
        if bioText == defaultPlaceholderText {
            bioText = ""
        }
        
        UserController.shared.updateUser(withID: currentUser.userID, email: currentUser.email, displayName: displayName, biography: bioText, profileImage: image)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Method
    func updateViews(){
        guard let currentUser = currentUser else { return }
        
        if let usersBioText = currentUser.biography {
            bioTextView.text = usersBioText
        } else {
            bioTextView.text = defaultPlaceholderText
        }
        
        displayNameTextField.text = currentUser.displayName
        
        if let imageData = currentUser.profileImage {
            profileImageView.image = UIImage(data: imageData)
        }
        
        followersCountLabel.text = "\(currentUser.followedByRefs.count)"
        followingCountTextLabel.text = "\(currentUser.followingRefs.count)"
        
    }
    
    func setCurrentUserLandingPad(){
        guard let currentUser = UserController.shared.currentUser else {
            print("🍒 Can't find a current user. Printing from \(#function) \n In \(String(describing: EditProfileViewController.self)) 🍒"); return
        }
        self.currentUser = currentUser
    }
    
    func resignAllTextFields(){
        bioTextView.resignFirstResponder()
        displayNameTextField.resignFirstResponder()
    }
    
    
    func deleteUser(){
        guard let currentUser = currentUser else { return }
        alertAndHandleProfileDeletion(forUserID: currentUser.userID)
    }
    
    
    func alertAndHandleProfileDeletion(forUserID userID: String) {
        let alertController = UIAlertController(title: "Confirm deletion.", message: "Are you sure you want to delete your profile?\nAll your created and saved recipes will be deleted.\nThis cannot be undone.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addItemAction = UIAlertAction(title: "Yes, delete me and all these tasty recipes.", style: .default) { (_) in
            UserController.shared.deleteUser(withID: userID)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addItemAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Extensions

extension EditProfileViewController: ImagePickerHelperDelegate {
    
    func fireActionsForSelectedImage(_ image: UIImage) {
        resignAllTextFields()
        profileImageView.image = image
    }
    
}


extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.bioTextView.becomeFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
}
