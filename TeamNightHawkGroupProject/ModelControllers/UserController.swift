//
//  UserController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import Firebase



class UserController {
    
    //MARK: - Singleton
    static let shared = UserController()
    
    
    //MARK: - Properties
    lazy var db = Firestore.firestore()
    var userListener: ListenerRegistration!
    var currentUser: User? {
        didSet {
            RecipeController.shared.currentUser = self.currentUser
        }
    }
    
    
    //MARK: - CRUD Functions
    
    /// Creates new user
    ///
    /// - Parameters:
    ///   - userID: Users userID
    ///   - email: Users Email
    ///   - displayName: Users displayname
    ///   - biography: Users bio
    ///   - image: Users display image
    ///   - completion: completes with true if creating user is successful
    func createUser(userID: String, withEmail email: String, displayName: String, biography: String, profileImage image: UIImage?, completion: @escaping (Bool) -> Void){
        let user = User(userID: userID, email: email, displayName: displayName, biography: biography, profileImage: image)
        
        let userRef = db.collection("Users")
        let userDictionary = user.dictionaryRepresentation
        userRef.document(user.userID).setData(userDictionary)
        currentUser = user
        completion(true)
    }
    
    func fetchUser(withUserRef ref: String, completion: @escaping (User) -> Void) {
        let userReference = db.collection("Users").document(ref)
        userReference.getDocument { (snapshot, error) in
            if let error = error {
                print("There was an error fetching user: \(error.localizedDescription)")
            }
            guard let data = snapshot?.data(),
                let user = User(document: data) else {return}
            
            completion(user)
            return
        }
    }
    
    func updateUser(withID userID: String, email: String, displayName: String, biography: String, profileImage: UIImage?){
        let userRef = db.collection("Users").document(userID)
        userRef.updateData([
            "email" : email,
            "displayName" : displayName,
            "biography" : biography,
            "profileImage" : profileImage?.jpegData(compressionQuality: 0.1) ?? UIImage()])
        
        currentUser?.email = email
        currentUser?.displayName = displayName
        currentUser?.biography = biography
        currentUser?.profileImage = profileImage?.jpegData(compressionQuality: 0.1)
    }
    
    func deleteUser(withID userID: String){
        db.collection("Recipes").whereField("userReference", isEqualTo: userID).getDocuments { (snapshot, error) in
            if let error = error {
                print("there was an error fetching documents: \(error)")
            }
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let documentID = document.documentID
                self.db.collection("Recipes").document(documentID).delete()
            }
        }
        db.collection("Users").document(userID).delete()
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            if let error = error {
                print("Can not delete; \(error.localizedDescription)")
            }
        })
    }
    
    //MARK: - User Methods
    
    func blockUser(withID userID: String){
        guard let currentUser = UserController.shared.currentUser else {return}
        let currentUserRef = db.collection("Users").document(currentUser.userID)
        currentUserRef.updateData(["blockedUserRefs" : FieldValue.arrayUnion([userID])])
        unfollowUser(withID: userID)
        currentUser.blockedUserRefs.append(userID)
    }
    
    func followUser(withID userID: String){
        guard let currentUser = UserController.shared.currentUser else { print("🍒 There's no current user or user to follow is not found. Printing from \(#function) in UserController 🍒"); return }
        
        let currentUserRef = db.collection("Users").document(currentUser.userID)
        currentUserRef.updateData(["followingRefs" : FieldValue.arrayUnion([userID])])
        currentUser.followingRefs.append(userID)
        fetchUser(withUserRef: userID) { (user) in
            user.followedByRefs.append(currentUser.userID)
        }
        let followedUserRef = db.collection("Users").document(userID)
        followedUserRef.updateData(["followedByRefs" : FieldValue.arrayUnion([currentUser.userID])])
    }

    func unfollowUser(withID userID: String){
        guard let currentUser = currentUser else { print("🍒 There's no current user or user to unfollow is not found. Printing from \(#function) in UserController 🍒"); return }
        
        let currentUserRef = db.collection("Users").document(currentUser.userID)
        currentUserRef.updateData(["followingRefs" : FieldValue.arrayRemove([userID])])
        
        let indexOfUser = currentUser.followingRefs.firstIndex(where: {$0 == userID})
        currentUser.followingRefs.remove(at: indexOfUser!)
        
        let followedUserRef = db.collection("Users").document(userID)
        followedUserRef.updateData(["followedByRefs" : FieldValue.arrayRemove([currentUser.userID])])
    }
    
    func unblockUser(withID blockedUserID: String){
        guard let currentUser = currentUser
            else { print("🍒 There's no current user. Printing from \(#function) \n In \(String(describing: UserController.self)) 🍒"); return }
        
        let currentUserRef = db.collection("Users").document(currentUser.userID)
        currentUserRef.updateData(["blockedUserRefs" : FieldValue.arrayRemove([blockedUserID])])
    }
}

