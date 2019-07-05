//
//  FetchViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/26/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import FirebaseAuth

class FetchViewController: UIViewController {
    
    //MARK: - Properties
    var handle: AuthStateDidChangeListenerHandle?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().backgroundColor = green
        handle = Auth.auth().addStateDidChangeListener({ (auth, retrievedUser) in
            if retrievedUser == nil {
                self.performSegue(withIdentifier: "toLogin", sender: nil)
            } else {
                guard let userRef = retrievedUser?.uid else {return}
                UserController.shared.fetchUser(withUserRef: userRef, completion: { (user) in
                    guard let userRef = retrievedUser?.uid else {return}
                    UserController.shared.fetchUser(withUserRef: userRef, completion: { (user) in
                        UserController.shared.currentUser = user
                    })
                    UserController.shared.currentUser = user
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBar = storyBoard.instantiateViewController(withIdentifier: "tabController")
                    UIApplication.shared.windows.first?.rootViewController = tabBar
                })
            }
        })
    }
}
