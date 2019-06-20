//
//  SignInViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var profileImagePickerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var biographyTextView: UITextView!


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
            let biography = biographyTextView.text else {return}
        UserController.shared.createUser(withEmail: email, displayName: displayName, biography: biography, profileImage: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "tabController")
        UIApplication.shared.windows.first?.rootViewController = signUpViewController
        
    }
    
    @IBAction func cancelUserCreationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "signUpController")
        UIApplication.shared.windows.first?.rootViewController = signUpViewController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
