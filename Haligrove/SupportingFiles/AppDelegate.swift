//
//  AppDelegate.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-25.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        if #available(iOS 11.0, *) {
            //To change iOS 11 navigationBar largeTitle color
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.gray,
                                                                     NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(26)).instance]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.gray, NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(22)).instance]
        } else {
            // for default navigation bar title color
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.gray, NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(22)).instance]
        }
        
        let navStyles = UINavigationBar.appearance()
        navStyles.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(18)).instance]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey : AnyObject], for: UIControlState.normal)
        
        // Selected text
        let titleTextAttributesSelected = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(16)).instance] as [NSAttributedStringKey : Any]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        // Normal text
        let titleTextAttributesNormal = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), NSAttributedStringKey.font: Font(.installed(.bakersfieldLight), size: .custom(16)).instance] as [NSAttributedStringKey : Any]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        UISegmentedControl.appearance().tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        let tabbarItemAppearance = UITabBarItem.appearance()
        let attributes = [NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(12)).instance]
        tabbarItemAppearance.setTitleTextAttributes(attributes, for: .normal)
        
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
