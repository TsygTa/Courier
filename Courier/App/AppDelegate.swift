//
//  AppDelegate.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 30/07/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shield: UIView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else {
                print("Разрешение на уведомления не получено")
                return
            }
        }
        
        GMSServices.provideAPIKey("AIzaSyD547ofIG8E0Dj7CkUJzqfwHMSwLERqmY8")
        
        let controller: UIViewController
        
        if UserDefaults.standard.bool(forKey: "isLogin") {
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(MainViewController.self)
        } else {
            controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(LoginViewController.self)
        }
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let vc = self.window?.rootViewController, vc is UINavigationController,
            let currentVC = (vc as! UINavigationController).visibleViewController {
            if currentVC is Authorizable {
                (currentVC as! Authorizable).clearAuthFields()
            }
            shield = UIView()
            shield?.frame = CGRect.init(x: 0, y: 0, width: currentVC.view.bounds.width, height: currentVC.view.bounds.height)
            shield?.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            currentVC.view.addSubview(shield!)
        }
        self.sendNotificationRequest(content: self.makeNotificationContent(),
                                     trigger: self.makeIntervalNotificationTrigger())
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let shieldView = self.shield else { return }
        shieldView.removeFromSuperview()
        self.shield = nil
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.sendNotificationRequest(content: self.makeNotificationContent(),
                                     trigger: self.makeIntervalNotificationTrigger())
    }
}

// MARK: - Реализует настройки уведомлений
extension AppDelegate {
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Courier App"
        content.subtitle = "Message"
        content.body = "Return to the Application"
        content.badge = 4
        return content
    }
    
    private func makeIntervalNotificationTrigger() ->UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
    }
    
    private func sendNotificationRequest(content: UNNotificationContent,
                                         trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "AlarmMassege", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
