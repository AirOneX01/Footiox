//
//  AppDelegate.swift
//  My Score
//
//  Created by admin on 16.04.2024.
//

import UIKit
import FirebaseCore
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        FirebaseManager.loadNews()
        PurchaseManager.shared.setUp()
        
        AppsFlyerLib.shared().isDebug = true
        
        AppsFlyerLib.shared().appsFlyerDevKey = "CkkCzCDWSByPyGFtUsU8Fo"
        AppsFlyerLib.shared().appleAppID = "6499025270"
        
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 80)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification),
                name: UIApplication.didBecomeActiveNotification,
                object: nil)
        
        return true
    }
    
    @objc func didBecomeActiveNotification() {
        
        AppsFlyerLib.shared().customerUserID = PListManager.getId()
        AppsFlyerLib.shared().start()
        
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


}

