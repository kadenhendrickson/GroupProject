//
//  AppDelegate.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/14/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


struct MockUserKey {
    static let kaden = "4B734484-DC96-4C5D-A6C3-90ABA6697750"
    static let anne = "EADE9A7A-2443-4B8E-A557-58BFCD1EEA02"
    static let shane = "4F67515D-C1E9-40AA-A522-771A1688C1A5"
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

    

//            UserController.shared.createUser(withEmail: "kadenhendrickson4@gmail.com", displayName: "kaden", biography: "I am a person", profileImage: UIImage(named: "AnneCelery"))
//            RecipeController.shared.createRecipe(name: "pizza", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "1", prepTime: "1")
//            RecipeController.shared.createRecipe(name: "pizza", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "1", prepTime: "1")
//            RecipeController.shared.createRecipe(name: "pizza", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "1", prepTime: "1")
//
//            UserController.shared.createUser(withEmail: "anne@gmail.com", displayName: "Anne", biography: "I am a person", profileImage: UIImage(named: "AnneCelery"))
//            RecipeController.shared.createRecipe(name: "Chicken", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "2", prepTime: "4")
//            RecipeController.shared.createRecipe(name: "Chicken", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "2", prepTime: "4")
//            RecipeController.shared.createRecipe(name: "Chicken", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "2", prepTime: "4")
//
//           UserController.shared.createUser(withEmail: "shane@gmail.com", displayName: "shane", biography: "I am a person", profileImage: UIImage(named: "AnneCelery"))
//            RecipeController.shared.createRecipe(name: "Steak", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "4", prepTime: "4")
//            RecipeController.shared.createRecipe(name: "Steak", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "4", prepTime: "4")
//            RecipeController.shared.createRecipe(name: "Steak", image: UIImage(named: "AnneCelery")!, ingredients: [], steps: [], tags: [], servingSize: "4", prepTime: "4")
////////
        //Kaden
//        UserController.shared.fetchUser(withUserRef: MockUserKey.kaden) { (user) in
//                UserController.shared.currentUser = user
//            // Anne
//            UserController.shared.followUser(withID: MockUserKey.anne)
//
//            // Shane
//            UserController.shared.followUser(withID: MockUserKey.shane)
//            print("!!!!!!! \(UserController.shared.currentUser?.displayName)")
//        }
////
////
////        //Anne is now current
//        UserController.shared.fetchUser(withUserRef: MockUserKey.anne) { (user) in
//            UserController.shared.currentUser = user
//            UserController.shared.followUser(withID: MockUserKey.shane)
//            UserController.shared.followUser(withID: MockUserKey.kaden)
//            print("!!!!!!! \(UserController.shared.currentUser?.displayName)")
//        }
//
////        // Shane become current
//        UserController.shared.fetchUser(withUserRef: MockUserKey.shane) { (user) in
//            UserController.shared.currentUser = user
//            // Anne
//            UserController.shared.followUser(withID: MockUserKey.anne)
//
//            // Shane
//            UserController.shared.followUser(withID: MockUserKey.kaden)
//            print("!!!!!!! \(UserController.shared.currentUser?.displayName)")
//        }
//
////
////        // back to kaden
//        UserController.shared.fetchUser(withUserRef: MockUserKey.kaden) { (user) in
//            UserController.shared.currentUser = user
//            print("!!!!!!! \(UserController.shared.currentUser?.displayName)")
//        }
//////
//        MockData.shared.resetMockData()
//        MockData.shared.loadUser()
//        MockData.shared.printDummyInfo()
//        
//        let randomUser = UserController.shared.users.randomElement()?.value
//        UserController.shared.currentUser = randomUser
//        
        //MockData.shared.chooseDummyUser(withName: "bigBeardShane")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

