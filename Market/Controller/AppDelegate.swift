//
//  AppDelegate.swift
//  Market
//
//  Created by mac retina on 2/4/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import Firebase
import Braintree

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        initializePayPal()
        BTAppSwitch.setReturnURLScheme("com.omikhan..Market.payments")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//MARK : Paypal
    
    func initializePayPal(){
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction : "AduxrEMYMcL0_yOt3QQPkUO8qhBqygNus-aO8GjX9wwyGeApY6xQnH4eoslgEApv2T8wWO_w4cVHJoP_", PayPalEnvironmentSandbox : "sb-4otsd3317803@business.example.com"])
    }

}

