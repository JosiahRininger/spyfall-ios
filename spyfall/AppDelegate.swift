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
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var workItem = DispatchWorkItem {
            if UIApplication.shared.applicationState == .background {
                NotificationCenter.default.post(name: .gameInactive, object: nil)
            }
    }
    var networkErrorPopUp = NetworkErrorPopUpView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        setupSecondaryColor()
        window?.rootViewController = NavigationController(rootViewController: HomeController())
        window?.addSubview(networkErrorPopUp)
        ErrorManager.setPopUp(networkErrorPopUp)
        setupGoogleServices()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DispatchQueue.background(delay: 900.0, workItem: self.workItem)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        workItem.cancel()
        workItem = DispatchWorkItem {
            if UIApplication.shared.applicationState == .background {
                NotificationCenter.default.post(name: .gameInactive, object: nil)
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.post(name: .gameInactive, object: nil)
    }
    
    //MARK: - Setup Methods
    private func setupSecondaryColor() {
        if let colorString = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.secondaryColor) {
            switch colorString {
            case ColorOptions.purple.rawValue: UIColor.secondaryColor = UIColor.customPurple
            case ColorOptions.blue.rawValue: UIColor.secondaryColor = UIColor.customBlue
            case ColorOptions.green.rawValue: UIColor.secondaryColor = UIColor.customGreen
            case ColorOptions.orange.rawValue: UIColor.secondaryColor = UIColor.customOrange
            case ColorOptions.red.rawValue: UIColor.secondaryColor = UIColor.customRed
            case ColorOptions.random.rawValue: UIColor.secondaryColor = UIColor.colors.randomElement()?.value ?? UIColor.blue
            default: os_log("Could not correctly assign secondaryColor")
            }
        } else {
            UserDefaults.standard.set("random", forKey: Constants.UserDefaultKeys.secondaryColor)
            UIColor.secondaryColor = UIColor.colors.randomElement()?.value ?? UIColor.blue
        }
    }
    
    private func setupGoogleServices() {
        FirebaseApp.configure()
        FirestoreService.listenForNetworkChanges()
        
        #if FREE
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        #if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["2077ef9a63d2b398840261c8221a0c9b"] // Sample device ID
        #endif
        
        #endif
    }
}
