//
//  UserController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit



class UserController {
    
    //MARK: - Singleton
    static let shared = UserController()
    
    // Dummy user's dictionary, deleting this later when we have a Source of Truth file to refer to
    var users: [String:User] = [:]
    var currentUser: User?
    
    //MARK: - Methods
    func followUser(withID userID: String){
        guard let currentUser = currentUser,
            let userToFollow = users[userID]
        else { print("🍒 There's no current user or user to follow is not found. Printing from \(#function) in UserController 🍒"); return }
        
        // Make that user has current user as a follower, and add that user to current user's following
        userToFollow.followedByRefs.append(currentUser.userID)
        currentUser.followingRefs.append(userToFollow.userID)
    }

    
    func unfollowUser(withID userID: String){
        guard let currentUser = currentUser,
            let userToUnfollow = users[userID]
            else { print("🍒 There's no current user or user to unfollow is not found. Printing from \(#function) in UserController 🍒"); return }
        
        guard let indexInFollowedByRef = userToUnfollow.followedByRefs.firstIndex(of: currentUser.userID),
            let indexInFollowingRef = currentUser.followingRefs.firstIndex(of: userToUnfollow.userID)
        else { return }
        
        // Remove current user from that user's follower, and from current user's following
        userToUnfollow.followedByRefs.remove(at: indexInFollowedByRef)
        currentUser.followingRefs.remove(at: indexInFollowingRef)
    }

    
    //MARK: - CRUDs
    func createUser(withEmail email: String, displayName: String, biography: String, profileImage: UIImage?){
        let user = User(email: email, displayName: displayName, biography: biography, profileImage: profileImage)
        let userID = user.userID
        users[userID] = user
    }
    
    func updateUser(withID userID: String, email: String, displayName: String, biography: String, profileImage: UIImage?){
        //replace original values with new values
        guard let user = users[userID]
            else { print("🍒 Can't find user to update. Printing from \(#function) in UserController 🍒"); return }
        user.email = email
        user.displayName = displayName
        user.biography = biography
        user.profileImage = profileImage
    }
    
    func deleteUser(withID userID: String){
        guard let userToDelete = users[userID] else { print("🍒 Can't find user to delete. Printing from \(#function) in UserController 🍒"); return }
        
        //also remove user's recipes
        for recipeRef in userToDelete.recipesRef {
            RecipeController.shared.deleteRecipeWith(id: recipeRef)
        }
        
        users.removeValue(forKey: userID)
    }
    
    //MARK: - Persistence
    func saveToPersistence(){
        
    }
    
    func loadFromPersistence(){
        
    }
    
}
