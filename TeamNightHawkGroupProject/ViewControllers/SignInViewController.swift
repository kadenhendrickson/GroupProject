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
        userEmail.delegate = self
        userPassword.delegate = self
    }
    
    @IBAction func loginUserButtonTapped(_ sender: UIButton) {
        guard let email = userEmail.text,
            let password = userPassword.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in \(error.localizedDescription)")
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
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
