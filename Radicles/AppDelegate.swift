//
//  AppDelegate.swift
//  Radicles
//
//  Created by William Tachau on 9/15/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginDelegate, LogoutDelegate {

    var window: UIWindow?

    // The current user
    var currentUser : PFUser?
    var iSLoggedIn : Boolean?
    
    var loginController : RADLoginViewController?
    var navigationController: UINavigationController?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("aCnkUAmAJHoxsLebFIyfkotl2nhIZv2nK0a9JoQ8", clientKey: "RBORg25gzX0N68csxfQdgoPTBomjnwm3CKtdkzsD");
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
        
        loginController = RADLoginViewController()
        loginController?.delegate = self
    
        // See if user is logged in or not
        self.currentUser = PFUser.currentUser()
        (currentUser != nil) ? showApp() : showLogin()
        
        return true
    }
    
    // Pushes the login view controller as root of nav controller
    func showLogin() {
      
      self.currentUser = PFUser.currentUser()
      
        self.navigationController = UINavigationController(rootViewController: loginController!)
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = backgroundColor
            navBar.translucent = false
            navBar.tintColor = UIColor.whiteColor()
            navBar.titleTextAttributes = NSDictionary(dictionary: [UIColor.whiteColor():NSForegroundColorAttributeName])
        }
        self.window!.rootViewController = self.navigationController
    }
    
    // Pushes the home view controller as root of nav controller
    func showApp() {
        let plantsView = RADAllPlantsTableViewController()
        plantsView.logoutDelegate = self
        self.navigationController = UINavigationController(rootViewController: plantsView)
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = backgroundColor
            navBar.translucent = false
            navBar.tintColor = UIColor.whiteColor()
            navBar.titleTextAttributes = NSDictionary(dictionary: [UIColor.whiteColor():NSForegroundColorAttributeName])
        }
        self.window!.rootViewController = self.navigationController
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

