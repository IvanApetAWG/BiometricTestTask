//
//  AppDelegate.swift
//  BiometricTestTask
//
//  Created by Ivan Apet on 08.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupFirstVC()
        return true
    }
}


extension AppDelegate {
    func setupFirstVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc: UIViewController!
        if let pin = UserDefaults.standard.value(forKey: "pin") as? String {
            vc = AuthorizationViewController.loadFromNib()
        } else {
            vc = ProfileViewController.loadFromNib()
        }
        
        let navig = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        window?.rootViewController = navig
    }
}
