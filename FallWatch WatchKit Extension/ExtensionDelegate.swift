//
//  ExtensionDelegate.swift
//  FallWatch WatchKit Extension
//
//  Created by Evan Stoddard on 10/21/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    let healthStore = HKHealthStore()

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        print("applicationDidFinishLaunching")
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        print("applicationWillResignActive")
    }
    
    func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
        if identifier == "FIRST_ACTION" {
            //FWNotification.sharedInstance.notificationDismissed()
        } else if identifier == "SECOND_ACTION" {
            //FWNotification.sharedInstance.helpNeeded()
        }
    }

}
