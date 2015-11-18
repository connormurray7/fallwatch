//
//  AppDelegate.swift
//  FallWatch
//
//  Created by Evan Stoddard on 10/21/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import UIKit
import Contacts
import HealthKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let healthStore = HKHealthStore()
    var window: UIWindow?
    var store = CNContactStore()
    func checkAccessStatus(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
        case .Denied, .NotDetermined:
            self.store.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                } else {
                    print("access denied")
                }
            })
        default:
            completionHandler(accessGranted: false)
        }
    }
    //class func getAppDelegate() -> AppDelegate {
    //    return UIApplication.sharedApplication().delegate as! AppDelegate
    //}
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override init() {
        healthStore.enableBackgroundDeliveryForType(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!, frequency: HKUpdateFrequency.Immediate) { (success, nser) -> Void in
            print("running")
        }
    }

    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Actions
        // Appears in red when the app loads
        let firstAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION" // check if the identifier has been checked
        firstAction.title = "Cancel"
        
        // Mode Background activation, this will update information in the app without launching the app when the user clicks on it.
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        // Appears in Blue when the app loads
        let secondAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Get Help!"
        // foreground activation, the app will launch when the user activates the notification
        secondAction.activationMode = UIUserNotificationActivationMode.Foreground
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        

        
        // group actions into a category
        let firstCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let defaultActions:NSArray = [firstAction, secondAction]
        let minimalAction:NSArray = [firstAction, secondAction]
        // actions that will be displayed in the notification center, log screen and in the banner
        
        firstCategory.setActions(defaultActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalAction as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of our categories
        let categories = NSSet(object: firstCategory)
        
        
        // Allow for local notifications, the user can allow/disallow for the notifications in Settings
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: categories as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        return true
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        if identifier == "FIRST_ACTION"
        {
            NSNotificationCenter.defaultCenter().postNotificationName("actionOnePressed", object: nil)
        }
        else if identifier == "SECOND_ACTION"
        {
            NSNotificationCenter.defaultCenter().postNotificationName("actionTwoPressed", object: nil)
        }
        
        completionHandler()
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // authorization from watch
    func applicationShouldRequestHealthAuthorization(application: UIApplication) {
        
        healthStore.handleAuthorizationForExtensionWithCompletion { success, error in
            
        }
    }

}

