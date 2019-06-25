//
//  User.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

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
    
    init(userID: String = UUID().uuidString, recipesRef: [String] = [], email: String, displayName: String, biography: String?, profileImage: UIImage?, savedRecipeRefs: [String] = [], followedBy: [String] = [], following: [String] = [], blockedUserRefs: [String] = []) {
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
                "biography" : biography,
                "profileImage" : profileImage,
                "savedRecipeRefs" : savedRecipeRefs,
                "followedByRefs" : followedByRefs,
                "followingRefs" : followingRefs,
                "blockedUserRefs" : blockedUserRefs ]
    }
}




extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
    
}
