//
//  AppDelegate.swift
//  URLPractice
//
//  Created by Josiah Rininger on 4/10/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ProgrammaticViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let vc = window?.rootViewController as! ProgrammaticViewController
        vc.urlLabel.text = url.absoluteString
        vc.urlLabel.text?.removeFirst(21)
        return true
    }
    
}
