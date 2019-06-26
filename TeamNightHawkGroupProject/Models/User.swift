//
//  User.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import Firebase

struct UserKeys {
    static let userCollectionKey = "Users" /* key in FireStore is plural */
    static let userIDKey = "userID"
    static let recipesRefKey = "recipeRef"
    static let emailKey = "email"
    static let displayNameKey = "displayName"
    static let biographyKey = "biography"
    static let profileImageKey = "profileImage"
    static let savedRecipeRefsKey = "savedRecipeRefs"
    static let followedByRefsKey = "followedByRefs"
    static let followingRefsKey = "followingRefs"
    static let blockedUserRefsKey = "blockedUserRefs"
    static let dictionaryRepresentationKey = "dictionaryRepresentation"
}

class User: Codable {
    let userID: String
    var recipesRef: [String]
    var email: String
    var displayName: String
    var biography: String?
    var profileImage: Data?
    var savedRecipeRefs: [String]
    var followedByRefs: [String]
    var followingRefs: [String]
    var blockedUserRefs: [String]
    
    init(userID: String, recipesRef: [String] = [], email: String, displayName: String, biography: String?, profileImage: UIImage?, savedRecipeRefs: [String] = [], followedBy: [String] = [], following: [String] = [], blockedUserRefs: [String] = []) {
        self.userID = userID
        self.email = email
        self.displayName = displayName
        self.biography = biography
        self.savedRecipeRefs = savedRecipeRefs
        self.followedByRefs = followedBy
        self.followingRefs = following
        self.blockedUserRefs = blockedUserRefs
        self.recipesRef = recipesRef
        self.profileImage = profileImage?.jpegData(compressionQuality: 0.1 )
    }
    
    
    
    var dictionaryRepresentation: [String : Any] {
        return ["userID" : userID,
                "recipeRef" : recipesRef,
                "email" : email,
                "displayName" : displayName,
                "biography" : biography ?? "",
                "profileImage" : profileImage ?? "",
                "savedRecipeRefs" : savedRecipeRefs,
                "followedByRefs" : followedByRefs,
                "followingRefs" : followingRefs,
                "blockedUserRefs" : blockedUserRefs ]
    }
    
    // take in document (dictionary of string to any) and then create a user
    convenience init?(document: QueryDocumentSnapshot) {
        guard let userID = document[UserKeys.userIDKey] as? String,
            let recipeRef = document[UserKeys.recipesRefKey] as? [String],
            let savedRecipeRefs = document[UserKeys.savedRecipeRefsKey] as? [String],
            let email = document[UserKeys.emailKey] as? String,
            let displayName = document[UserKeys.displayNameKey] as? String,
            let biography = document[UserKeys.biographyKey] as? String?,
            let profileImage = document[UserKeys.profileImageKey] as? Data,
            let followedByRefs = document[UserKeys.followedByRefsKey] as? [String],
            let followingRefs = document[UserKeys.followingRefsKey] as? [String],
            let blockedUserRefs = document[UserKeys.blockedUserRefsKey] as? [String]
            else { print("🍒 Failed to cast all of user's property from document snapshot. Printing from \(#function) \n In \(String(describing: User.self)) 🍒"); return nil}
        
        self.init(userID: userID, recipesRef: recipeRef, email: email, displayName: displayName, biography: biography, profileImage: UIImage(data: profileImage), savedRecipeRefs: savedRecipeRefs, followedBy: followedByRefs, following: followingRefs, blockedUserRefs: blockedUserRefs)
    }
}


extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
    
}

