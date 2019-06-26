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


    //MARK: - IBOutlets
    @IBOutlet weak var profileImagePickerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - IBActions
    @IBAction func setProfileImageButtonTapped(_ sender: UIButton) {
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
            Firestore.firestore().collection("User").document(userID).setData([
                "biography" : biography,
                "displayName" : displayName,
                "profileImage" : profileImage.jpegData(compressionQuality: 0.1)!
                ], completion: { (error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "tabController")
                            UIApplication.shared.windows.first?.rootViewController = signUpViewController
                    }
            })
        }
//        UserController.shared.createUser(withEmail: email, displayName: displayName, biography: biography, profileImage: nil)
//
        
    }
    
    @IBAction func cancelUserCreationButtonTapped(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "signUpController")
//        UIApplication.shared.windows.first?.rootViewController = signUpViewController
        dismiss(animated: true, completion: nil)
    }
}
