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
    let recipesRef: [String]
    var email: String
    var displayName: String
    var biography: String?
    var profileImage: Data?
    var savedRecipeRefs: [String]
    var followedByRefs: [String]
    var followingRefs: [String]
    var blockedUserRefs: [String]
    
    init(userID: String = UUID().uuidString, recipesRef: [String] = [], email: String, displayName: String, biography: String?, profileImage: UIImage?, savedRecipeRefs: [String] = [], followedBy: [String] = [], following: [String] = [], blockedUserRefs = []) {
        self.userID = userID
        self.email = email
        self.displayName = displayName
        self.biography = biography
        self.savedRecipeRefs = savedRecipeRefs
        self.followedByRefs = followedBy
        self.followingRefs = following
        self.blockedUserRefs = blockedUserRefs
        self.recipesRef = recipesRef
        self.profileImage = profileImage?.pngData()
    }
}


extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userID == rhs.userID
    }
    
}
