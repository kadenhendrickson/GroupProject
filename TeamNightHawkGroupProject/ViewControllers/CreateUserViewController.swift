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
    @IBOutlet weak var profileImageView: UIImageView!
    
    let defaultPlaceholderText: String = "Something about yourself ..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sign Up"

        profileImagePickerButton.setTitle("Select image", for: .normal)
        profileImagePickerButton.layer.cornerRadius = 2
        profileImagePickerButton.layer.borderWidth = 0.5
        profileImagePickerButton.layer.borderColor = grey.cgColor
        
        emailTextField.delegate = self
        displayNameTextField.delegate = self
        passwordTextField.delegate = self
        biographyTextView.delegate = self
        imagePicker.delegate = self
        
        biographyTextView.text = defaultPlaceholderText
        emailTextField.tag = 0
        displayNameTextField.tag = 1
        passwordTextField.tag = 2
        biographyTextView.tag = 3
    }
    
    
    //MARK: - IBActions
    @IBAction func setProfileImageButtonTapped(_ sender: UIButton) {
        imagePicker.presentImagePicker(for: self)
    }
    
    @IBAction func createUserButtonTapped(_ sender: UIButton) {
        triggerCreatUser()
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        resignAllTextFields()
    }
    
    @IBAction func userSwipedDown(_ sender: Any) {
        resignAllTextFields()
    }
    
    @IBAction func cancelUserCreationButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func alertUser(withMessage message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
   func resignAllTextFields() {
        biographyTextView.resignFirstResponder()
        emailTextField.resignFirstResponder()
        displayNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func triggerCreatUser(){
        
        // Assign default in case user didn't provide data
        var biography = ""
        var profileImage = UIImage(named: "duck")
        
        guard let displayName = displayNameTextField.text,
            displayName.count < 20 else {
                alertUser(withMessage: "Please limit your displayname to less than 20.")
                return
        }
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                alertUser(withMessage: "Please fill our email and password.")
                return
        }
        
        if let bioTextViewText = biographyTextView.text, bioTextViewText != defaultPlaceholderText {
            biography = bioTextViewText
        }
        
        if let image = profileImageView.image {
            profileImage = image
        }
        
        resignAllTextFields()
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.alertUser(withMessage: "\(error.localizedDescription)")
                print("There was an error creating a user: \(error.localizedDescription)")
                return
            }
            
            let changeRequest = result?.user.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    self.alertUser(withMessage: "\(error.localizedDescription)")
                    print("There was a problem adding the displayName: \(error.localizedDescription)")
                }
            })
            guard let userID = result?.user.uid else {return}
            UserController.shared.createUser(userID: userID, withEmail: email, displayName: displayName, biography: biography, profileImage: profileImage, completion: { (success) in
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let signUpViewController = storyboard.instantiateViewController(withIdentifier: "tabController")
                    UIApplication.shared.windows.first?.rootViewController = signUpViewController
                }
            })
        }
    }
}

extension  CreateUserViewController: ImagePickerHelperDelegate {
    func fireActionsForSelectedImage(_ image: UIImage) {
        resignAllTextFields()
        profileImageView.image = image
        profileImagePickerButton.setTitle("", for: .normal)
        profileImagePickerButton.layer.borderWidth = 0
    }
}

extension CreateUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            //go to textview
            let bioTextView = self.view.viewWithTag(textField.tag + 1) as? UITextView
            bioTextView?.becomeFirstResponder()
        }
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
