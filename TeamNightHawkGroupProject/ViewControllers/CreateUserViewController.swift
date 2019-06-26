//
//  CreateUserViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class CreateUserViewController: UIViewController {

    //MARK: - Properties
    var imagePicker = ImagePickerHelper()

    //MARK: - IBOutlets
    @IBOutlet weak var profileImagePickerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImagePickerButton.setTitle("Select an image", for: .normal)
        emailTextField.delegate = self
        displayNameTextField.delegate = self
        passwordTextField.delegate = self
        biographyTextView.delegate = self
        imagePicker.delegate = self
    }
    
    
    //MARK: - IBActions
    @IBAction func setProfileImageButtonTapped(_ sender: UIButton) {
        imagePicker.presentImagePicker(for: self)
    }
    
    @IBAction func createUserButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let displayName = displayNameTextField.text,
            let biography = biographyTextView.text,
            let profileImage = profileImage.image,
        let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("There was an error creating a user: \(error.localizedDescription)")
                return
            }
            let changeRequest = result?.user.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    print("There was a problem adding the displayName: \(error.localizedDescription)")
                }
            })
            guard let userID = result?.user.uid else {return}
            UserController.shared.createUser(userID: userID, withEmail: email, displayName: displayName, biography: biography, profileImage: profileImage, completion: { (success) in
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let signUpViewController = storyboard.instantiateViewController(withIdentifier: "feedController")
                    UIApplication.shared.windows.first?.rootViewController = signUpViewController
                }
            })
//
            
            //Firestore.firestore().collection("User").document(userID).setData([
//                "biography" : biography,
//                "displayName" : displayName,
//                "profileImage" : profileImage.jpegData(compressionQuality: 0.1)!
//                ], completion: { (error) in
//                if let error = error {
//                    print("\(error.localizedDescription)")
//                    return
//                }else{
//
//                    }
            //})
        }
//        UserController.shared.createUser(withEmail: email, displayName: displayName, biography: biography, profileImage: nil)
//
        
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        biographyTextView.resignFirstResponder()
        emailTextField.resignFirstResponder()
        displayNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func cancelUserCreationButtonTapped(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "signUpController")
//        UIApplication.shared.windows.first?.rootViewController = signUpViewController
        dismiss(animated: true, completion: nil)
    }
}

extension  CreateUserViewController: ImagePickerHelperDelegate {
    func fireActionsForSelectedImage(_ image: UIImage) {
        profileImage.image = image
        profileImagePickerButton.setTitle("", for: .normal)
        
    }
}

extension CreateUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateUserViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
