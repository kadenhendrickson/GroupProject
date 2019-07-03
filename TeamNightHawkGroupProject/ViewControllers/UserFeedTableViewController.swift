//
//  UserFeedTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI

class UserFeedTableViewController: UITableViewController, UserFeedTableViewCellDelegate{
    //MARK: - Properties
    var recipesList: [Recipe]? {
        didSet{
            tableView.reloadData()
        }
    }
    var usersList: [User]?
    
    var selectedUser: User?
    
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        self.tableView.separatorStyle = .none
        tableView.tableHeaderView?.tintColor = softBlue
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadUsers { (success) in
            if success {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

    
    //helper functions
    func loadUsers(_ completion: @escaping(Bool) -> Void) {
        usersList = []
        recipesList = []
        guard let currentUser = UserController.shared.currentUser else { completion(false); return}
        
        var currentUserFollowingRefs = currentUser.followingRefs
        currentUserFollowingRefs.append(currentUser.userID)
        
        for userRef in currentUserFollowingRefs {
            UserController.shared.fetchUser(withUserRef: userRef) { (user) in
                self.usersList?.append(user)
                RecipeController.shared.fetchSpecificRecipesWith(userReference: userRef, completion: { (recipes) in
                    self.recipesList?.append(contentsOf: recipes)
                    self.recipesList?.sort{$1.timestamp < $0.timestamp}
                })
            }
        }
        
        completion(true)
        return
    }
    
    func findUserForRecipe(with recipe: Recipe) -> User? {
        guard let usersList = usersList else {return nil}
        for user in usersList {
            if recipe.userReference == user.userID {
                return user
            }
        }
        return nil
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.loadUsers { (success) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.refreshController.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = recipesList?.count else {return 0}
        print("\(numberOfRows)")
        return numberOfRows
    }
    
    //dont forget to change reuseIdentifier
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFeedRecipeCell", for: indexPath) as? UserFeedTableViewCell
        guard let recipe = recipesList?[indexPath.row],
            let currentUserRecipeRefs = UserController.shared.currentUser?.savedRecipeRefs else {return UITableViewCell()}
        
        cell?.delegate = self
        cell?.recipe = recipe
        cell?.user = findUserForRecipe(with: recipe)
        if currentUserRecipeRefs.contains(recipe.recipeID) {
            
            //cell?.saveRecipeButton.setTitle("", for: .normal)
            cell?.saveRecipeButton.setBackgroundImage(UIImage(named: "savedBookmark"), for: .normal)
        } else {
            //cell?.saveRecipeButton.setTitle("", for: .normal)
            cell?.saveRecipeButton.setBackgroundImage(UIImage(named: "unsavedBookmark"), for: .normal)
        }
        
        //cell?.toggleSavedStatus()
        return cell ?? UITableViewCell()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFeedToRecipeDVC" {
            guard let destinationVC = segue.destination as? RecipeDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let recipe = recipesList?[indexPath.row] else {return}
            
            destinationVC.recipe = recipe
            destinationVC.user = selectedUser
            destinationVC.navigationTitle = recipe.name
        }
        
        if segue.identifier == "fromFeedToOtherUserVC" {
            guard let destinationVC = segue.destination as? UserViewedTableViewController else {return}
            
            destinationVC.user = selectedUser
            
            guard let displayName = selectedUser?.displayName else { return }
            destinationVC.navigationTitle = displayName
        }
    }
    
    func popAlert() {
        alertUser(withMessage: "Would you like to report this post and block this user?")
    }
    
    func userRefSent(userRef: String) {
        UserController.shared.fetchUser(withUserRef: userRef) { (user) in
            self.selectedUser = user
            self.performSegue(withIdentifier: "fromFeedToOtherUserVC", sender: nil)
            
        }
    }
    func alertUser(withMessage message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let reportPost = UIAlertAction(title: "Report/Block", style: .default) { (_) in
            guard let userID = self.selectedUser?.userID else {return}
            UserController.shared.blockUser(withID: userID)
            self.loadUsers({ (success) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            self.sendEmail(userID: userID)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(reportPost)
        self.present(alertController, animated: true)
    }
}

extension UserFeedTableViewController: MFMailComposeViewControllerDelegate {
    func sendEmail(userID: String){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["chefologydvm@gmail.com"])
            mail.setSubject("Reporting email")
            mail.setMessageBody("The following user has posted an inappropriate item. Please look into removing the account for \(userID). Regards \(UserController.shared.currentUser!.displayName)", isHTML: true)
            present(mail, animated: true)
        } else {
            print("this device can't send email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
