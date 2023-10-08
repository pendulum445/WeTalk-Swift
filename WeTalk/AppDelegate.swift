//
//  AppDelegate.swift
//  WeTalk
//
//  Created by liaoyunjie on 2023/9/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init()
        window?.rootViewController = UINavigationController(rootViewController: MainTabBarController())
        UINavigationBar.appearance().isHidden = true
        window?.makeKeyAndVisible()
        return true
    }
}
