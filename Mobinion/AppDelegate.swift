//
//  AppDelegate.swift
//  Mobinion
//
//  Created by Mohammed Shaneeb on 3/13/16.
//  Copyright © 2016 Novateurglow. All rights reserved.
//

import UIKit
import IQKeyboardManager
import GoogleMaps
import SVProgressHUD

enum Shortcut: String
{
    case aroundMe = "AroundMe"
    case qrCode = "QRCode"
//    case myWall = "MyWall"
    case createPoll = "CreatePoll"
    case myProfile = "MyProfile"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        
        GMSServices.provideAPIKey("AIzaSyCZh2o4lsPP0GtVoQOHeWfvzQ71wQGHvVM")
        
        print(NSUserDefaults.standardUserDefaults().objectForKey("token"))
        if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil
        {
            let toks = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
            print(toks)
            if !(toks.isEmpty)
            {
                // Access the storyboard and fetch an instance of the view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewControllerWithIdentifier("NewsFeedController") as! NewsFeedController
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        SVProgressHUD.setDefaultStyle(.Dark)
        
        return true
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void)
    {
        completionHandler(handleQuickAction(shortcutItem))
    }
    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- QuickActions
    func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool
    {
        var quickActionHandled = false
        let type = shortcutItem.type.componentsSeparatedByString(".").last!
        if let shortcutType = Shortcut.init(rawValue: type)
        {
            switch shortcutType
            {
                case .aroundMe:
                    if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil
                    {
                        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                        print(toks)
                        if !(toks.isEmpty)
                        {
                            // Access the storyboard and fetch an instance of the view controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("NewsFeedController") as! NewsFeedController
                            
                            initialViewController.selectedIndex = 0
                            
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                    quickActionHandled = true
                
                case .qrCode:
                    if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil
                    {
                        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                        print(toks)
                        if !(toks.isEmpty)
                        {
                            // Access the storyboard and fetch an instance of the view controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("NewsFeedController") as! NewsFeedController
                            
                            initialViewController.selectedIndex = 1
                            
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                    quickActionHandled = true
                
//                case .myWall:
//                    if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil
//                    {
//                        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
//                        print(toks)
//                        if !(toks.isEmpty)
//                        {
//                            // Access the storyboard and fetch an instance of the view controller
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("NewsFeedController") as! NewsFeedController
//                            
//                            initialViewController.selectedIndex = 2
//                            
//                            self.window?.rootViewController = initialViewController
//                            self.window?.makeKeyAndVisible()
//                        }
//                    }
//                    quickActionHandled = true
                
                case .createPoll:
                    if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil
                    {
                        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                        print(toks)
                        if !(toks.isEmpty)
                        {
                            // Access the storyboard and fetch an instance of the view controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("NewsFeedController") as! NewsFeedController
                            
                            initialViewController.selectedIndex = 3
                            
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                    quickActionHandled = true
                
                case .myProfile:
                    if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil
                    {
                        let toks = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                        print(toks)
                        if !(toks.isEmpty)
                        {
                            // Access the storyboard and fetch an instance of the view controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("NewsFeedController") as! NewsFeedController
                            
                            initialViewController.selectedIndex = 4
                            
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                    quickActionHandled = true
                
                default:
                break
            }
        }
        
        return quickActionHandled
    }

}

