//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Lydia Jones on 10/04/2017.
//  Copyright © 2017 Lydia Jones. All rights reserved.
//


import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
         super.viewDidLoad()
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        // This is the code to make sure the profile has the grid layout //
        
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected") // This is the code for adding in the profile icon to thr tab bar //
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
        
       }
    
    }
