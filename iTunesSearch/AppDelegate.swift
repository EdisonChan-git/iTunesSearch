//
//  AppDelegate.swift
//  iTunesSearch
//
//  Created by EDISON CHAN on 26/7/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    var homeSearchViewController: HomeSearchViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create a new window and set its root view controller to the app's main view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        homeSearchViewController = HomeSearchViewController(nibName: "HomeSearchViewController", bundle: nil)
        navController = UINavigationController(rootViewController: homeSearchViewController!)
        navController?.navigationBar.isHidden = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate.
    }
}
