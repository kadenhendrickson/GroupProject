//
//  SignInViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sign In"

        userEmail.delegate = self
        userPassword.delegate = self
        
        userEmail.tag = 0
        userPassword.tag = 1
    }
    
    @IBAction func loginUserButtonTapped(_ sender: UIButton) {
        triggerSignIn()
    }
    
    @IBAction func createUserButtonTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "toCreateUserVC", sender: nil)
        resignAllTextFields()
    }
    
    
    @IBAction func userTappedView(_ sender: Any) {
        self.resignAllTextFields()
        print("💌 User tapped view.")
    }
    
    
    @IBAction func userSwipedDown(_ sender: UISwipeGestureRecognizer) {
        self.resignAllTextFields()
        print("🧸 User swiped down.")
    }

    
    // MARK: - Functions
    func resignAllTextFields(){
        userEmail.resignFirstResponder()
        userPassword.resignFirstResponder()
    }
    
    func alertUser(withMessage message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    
    func triggerSignIn(){
        guard let email = userEmail.text,
            let password = userPassword.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in \(error.localizedDescription)")
                self.alertUser(withMessage: "Incorrect email / password.")
                return
            } else {
                // resign all textfields before changing view.
                self.resignAllTextFields()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let feedViewController = storyboard.instantiateViewController(withIdentifier: "tabController")
                UIApplication.shared.windows.first?.rootViewController = feedViewController
                guard let userRef = result?.user.uid else {return}
                UserController.shared.fetchUser(withUserRef: userRef, completion: { (user) in
                    UserController.shared.currentUser = user
                })
            }
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let passwordField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            passwordField.becomeFirstResponder()
        } else {
            //we are now in password field
            //resign first responder and trigger sign in
            textField.resignFirstResponder()
            triggerSignIn()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
