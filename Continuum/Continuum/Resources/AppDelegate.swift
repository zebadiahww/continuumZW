//
//  AppDelegate.swift
//  Continuum
//
//  Created by Zebadiah Watson on 10/15/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      checkAccountStatus { (success) in
        let fetchedUserStatment = success ? "Successfully retrieved a logged in user" : "Failed to retrieve a logged in user"
         print(fetchedUserStatment)
      }
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
        if let error = error {
          print("Error in \(#function) ; \(error)  ; \(error.localizedDescription)")
          return
        }
        success ? print("Success") : print("Unseccessful")
      }
      application.registerForRemoteNotifications()
      return true
    }

    func checkAccountStatus(completion: @escaping (Bool) -> Void) {
        CKContainer.default().accountStatus { (status, error) in
        if let error = error {
          print("Error checking accountStatus \(error) \(error.localizedDescription)")
          completion(false); return
        } else {
          DispatchQueue.main.async {
            let tabBarController = self.window?.rootViewController
            let errorText = "Sign into iCloud in Settings"
            switch status {
            case .available:
              completion(true);
            case .noAccount:
              tabBarController?.presentSimpleAlertWith(title: errorText, message: "No account found")
              completion(false)
            case .couldNotDetermine:
              tabBarController?.presentSimpleAlertWith(title: errorText, message: "There was an unknown error fetching your iCloud Account")
              completion(false)
            case .restricted:
              tabBarController?.presentSimpleAlertWith(title: errorText, message: "Your iCloud account is restricted")
              completion(false)
            }
          }
        }
      }
    }
}

