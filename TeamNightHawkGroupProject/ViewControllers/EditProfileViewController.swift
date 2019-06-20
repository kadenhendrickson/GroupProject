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
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentUserLandingPad()
        imagePicker.delegate = self
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //clear data
    }
    
    @IBAction func changeImageButtonTapped(_ sender: Any) {
        imagePicker.presentImagePicker(for: self)
    }
    
    @IBAction func deleteProfileButtonTapped(_ sender: Any) {
        guard let currentUser = currentUser else { return }
        UserController.shared.deleteUser(withID: currentUser.userID)
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: Any) {
        guard let currentUser = currentUser
        else { /* pop alert */ return }
        
        let image = profileImageView.image ?? nil
        
        
        UserController.shared.updateUser(withID: <#T##String#>, email: <#T##String#>, displayName: <#T##String#>, biography: <#T##String#>, profileImage: <#T##UIImage?#>)
    }
    
    // MARK: - Method
    func updateViews(){
        guard let currentUser = currentUser else { return }
        bioTextView.text = currentUser.biography
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

}

extension EditProfileViewController: ImagePickerHelperDelegate {
    
    func fireActionsForSelectedImage(_ image: UIImage) {
        profileImageView.image = image
    }
    
}
