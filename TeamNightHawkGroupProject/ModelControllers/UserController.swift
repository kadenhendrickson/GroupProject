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
    
    var users: [String:User] = [:]
    
    /**
     This get assigned when a new user is created.
     */
    var currentUser: User?
    
    //MARK: - Methods
    func followUser(withID userID: String){
        guard let currentUser = currentUser,
            let userToFollow = users[userID]
        else { print("🍒 There's no current user or user to follow is not found. Printing from \(#function) in UserController 🍒"); return }
        
        // Make that user has current user as a follower, and add that user to current user's following
        userToFollow.followedByRefs.append(currentUser.userID)
        currentUser.followingRefs.append(userToFollow.userID)
        
        saveUsersToPersistence()
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
        
        saveUsersToPersistence()
    }
    
    func blockUser(withID userID: String){
        
        guard let currentUser = currentUser else { print("🍒 There's no current user. Printing from \(#function) \n In \(String(describing: UserController.self)) 🍒"); return }
        
        currentUser.blockedUserRefs.append(userID)
        
    }
    
    func unblockUser(withID blockedUserID: String){
        
        guard let currentUser = currentUser,
            let refIndex = currentUser.blockedUserRefs.firstIndex(of: blockedUserID)
            else { print("🍒 There's no current user. Printing from \(#function) \n In \(String(describing: UserController.self)) 🍒"); return }
        
        currentUser.blockedUserRefs.remove(at: refIndex)
    }
    
    
    //MARK: - CRUDs
    func createUser(withEmail email: String, displayName: String, biography: String, profileImage: UIImage?){
        let user = User(email: email, displayName: displayName, biography: biography, profileImage: profileImage)
        let userID = user.userID
        users[userID] = user
        currentUser = user
        RecipeController.shared.currentUser = user
        saveUsersToPersistence()
    }
    
    func updateUser(withID userID: String, email: String, displayName: String, biography: String, profileImage: UIImage?){
        //replace original values with new values
        guard let user = users[userID]
            else { print("🍒 Can't find user to update. Printing from \(#function) in UserController 🍒"); return }
        user.email = email
        user.displayName = displayName
        user.biography = biography
        user.profileImage = profileImage?.pngData()
        
        saveUsersToPersistence()
    }
    
    func deleteUser(withID userID: String){
        guard let userToDelete = users[userID] else { print("🍒 Can't find user to delete. Printing from \(#function) in UserController 🍒"); return }
        
        //also remove user's recipes
        for recipeRef in userToDelete.recipesRef {
            RecipeController.shared.deleteRecipeWith(id: recipeRef)
        }
        
        users.removeValue(forKey: userID)
        
        saveUsersToPersistence()
    }
}

extension UserController {
    
    //MARK: - Local Persistence
    
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = "user.json"
        let documentaryDirectoryUrl = urls[0].appendingPathComponent(filename)
        return documentaryDirectoryUrl
    }
    
    func saveUsersToPersistence(){
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(users)
            let url = fileURL()
            try data.write(to: url)
        } catch {
            print("There was an error saving users \(error.localizedDescription)")
        }
    }
    
    func loadUsersFromPersistence() -> [String: User]{
        let jsonDecoder = JSONDecoder()
        do {
            let url = fileURL()
            let data = try Data(contentsOf: url)
            let users = try jsonDecoder.decode([String : User].self, from: data)
            return users
        } catch {
            print("There was an error loading user data \(error.localizedDescription)")
            return [:]
        }
    }
}
