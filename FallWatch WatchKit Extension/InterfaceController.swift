//
//  InterfaceController.swift
//  FallWatch WatchKit Extension
//
//  Created by Evan Stoddard on 10/4/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var toggleMonitoringBtn: WKInterfaceButton!
    var workoutSession: HKWorkoutSession?
    var monitoringOn = false
    var count = 0
    let accMonitor = FWAcceleration()
    let defaults = NSUserDefaults.init(suiteName: "group.me.fallwatch.FallWatch.defaults")!
    var seconds = 0
    // connect watch to iphone
    let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
     let healthStore = HKHealthStore()
    // let workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.Other, locationType: HKWorkoutSessionLocationType.Unknown)
    
    override init() {
        super.init()
        session?.delegate = self
        session?.activateSession()
        print("init InterfaceController")
        
        workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.Other, locationType: HKWorkoutSessionLocationType.Indoor)
    }
    
    @IBAction func toggleMonitoring() {
        
        if monitoringOn == false {
            monitoringOn = true
            
            // play haptic to signal monitoring has started
            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Start)

            accMonitor.startMonitoring()
            // healthStore.startWorkoutSession(workoutSession)
            
            // interface updates
            toggleMonitoringBtn.setBackgroundColor(UIColor.redColor())
            toggleMonitoringBtn.setTitle("STOP Monitoring")
            statusLabel.setTextColor(UIColor.greenColor())
            statusLabel.setText("Monitoring On")
            
            healthStore.startWorkoutSession(workoutSession!)
        }
            
        else {
            monitoringOn = false
            
            // play haptic to signal monitoring has ended
            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Stop)
            
            accMonitor.stopMonitoring()
            
            // interface updates
            toggleMonitoringBtn.setBackgroundColor(UIColor.greenColor())
            toggleMonitoringBtn.setTitle("START Monitoring")
            statusLabel.setTextColor(UIColor.redColor())
            statusLabel.setText("Monitoring Off")
            
            healthStore.endWorkoutSession(workoutSession!)
            
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let data = applicationContext["timer"] as? Int
        
        // use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            if let value = data {
                FWNotification.sharedInstance.setTimer(value);
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        print("awakeWithContext")
        // configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
        print("willActivate")
        // This method is called when watch view controller is about to be visible to user
        
//        var someSet = Set<HKSampleType>()
//        someSet.insert(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
//        print("cool")
//        healthStore.requestAuthorizationToShareTypes(nil, readTypes: someSet) { (bl : Bool, nser : NSError?) -> Void in
//            print("in here")
//        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        print("didDeactivate")
        // This method is called when watch view controller is no longer visible
    }
}
