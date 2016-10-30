//
//  AppDelegate.swift
//  SpeechRec
//
//  Created by gj on 2016/10/9.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        User.addDefaultUser()
        
        if User.isLogined {

            loginSuccess()
        } else {

            logOut()
        }
        
//        let isEarly = NSDate().compare(NSDate.dateFromString("2016-10-16", withFormat: "yyyy-MM-dd")) == .OrderedDescending
//        if isEarly {
//            exit(0)
//        }
        
        self.window!.makeKeyAndVisible()
        return true
    }

    /**
     login successfully
     */
    func loginSuccess() {
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: userDidLoginNotification, object: nil)
        
        let storyBoard = UIStoryboard(name: "Main",bundle: nil)
        let nav = storyBoard.instantiateViewControllerWithIdentifier("IndexNavigation")
        self.window!.rootViewController = nav
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.logOut), name: userDidLogOutNotification, object: nil)
        
    }
    
    /**
     logOut
     */
    func logOut() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: userDidLogOutNotification, object: nil)
        
        let storyBoard = UIStoryboard(name: "Main",bundle: nil)
        let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("UserLoginViewController")
        self.window!.rootViewController = loginViewController
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.loginSuccess), name: userDidLoginNotification, object: nil)
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


