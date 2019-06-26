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
                self.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signUpViewController = storyboard.instantiateViewController(withIdentifier: "feedController")
                UIApplication.shared.windows.first?.rootViewController = signUpViewController
            }
        }
    }
    
    @IBAction func createUserButtonTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "toCreateUserVC", sender: nil)
        
    }
    
    @IBAction func userTappedView(_ sender: Any) {
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
