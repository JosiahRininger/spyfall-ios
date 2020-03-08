//
//  AppDelegate.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/6/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    
        if let colorString = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.secondaryColor) {
            switch colorString {
            case ColorOptions.purple.rawValue: UIColor.secondaryColor = UIColor.customPurple
            case ColorOptions.blue.rawValue: UIColor.secondaryColor = UIColor.customBlue
            case ColorOptions.green.rawValue: UIColor.secondaryColor = UIColor.customGreen
            case ColorOptions.orange.rawValue: UIColor.secondaryColor = UIColor.customOrange
            case ColorOptions.red.rawValue: UIColor.secondaryColor = UIColor.customRed
            case ColorOptions.random.rawValue: UIColor.secondaryColor = UIColor.colors.randomElement()?.value ?? UIColor.blue
            default: print("Could not correctly")
            }
        } else {
            UserDefaults.standard.set("random", forKey: Constants.UserDefaultKeys.secondaryColor)
            UIColor.secondaryColor = UIColor.colors.randomElement()?.value ?? UIColor.blue
        }
        
        window?.rootViewController = NavigationController(rootViewController: HomeController())
        
        FirebaseApp.configure()
        
#if FREE
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        #if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ] // Sample device ID
        #endif
        
#endif
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DispatchQueue.background(delay: 900.0) {
            if UIApplication.shared.applicationState == .background {
                NotificationCenter.default.post(name: .gameInactive, object: nil)
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.post(name: .gameInactive, object: nil)
    }
    
}
