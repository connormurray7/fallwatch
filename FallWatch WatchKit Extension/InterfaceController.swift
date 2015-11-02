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
    var monitoringOn = false
    var count = 0
//    let healthStore = HKHealthStore()
//    let workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.Other, locationType: HKWorkoutSessionLocationType.Unknown)
    let accMonitor = FWAcceleration()
    let defaults = NSUserDefaults.init(suiteName: "group.me.fallwatch.FallWatch.defaults")!
    
    //connect watch to iphone
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }

    
    func update() {
        timeLabel.setText(String(count++))
    }
    
    @IBAction func toggleMonitoring() {
        
        if monitoringOn == false {
            monitoringOn = true
            print("on")

            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Start)
            
            testMsg();//testing
            //accMonitor.startMonitoring()
            
//            healthStore.startWorkoutSession(workoutSession)
            
            // interface updates
            toggleMonitoringBtn.setBackgroundColor(UIColor.redColor())
            toggleMonitoringBtn.setTitle("STOP Monitoring")
            statusLabel.setTextColor(UIColor.greenColor())
            statusLabel.setText("Monitoring On")
        }
            
        else {
            monitoringOn = false
            
            accMonitor.stopMonitoring()
            
            // interface updates
            toggleMonitoringBtn.setBackgroundColor(UIColor.greenColor())
            toggleMonitoringBtn.setTitle("START Monitoring")
            statusLabel.setTextColor(UIColor.redColor())
            statusLabel.setText("Monitoring Off")
            
        }
    }
    func testMsg()
    {
        print("send message to my contacts, I have fallen")
        let alert = "yes"
        let applicationDict = ["alert" : alert]
        do {
            print("Send alert")
            try self.session?.updateApplicationContext(applicationDict)
        } catch {
            print("error")
        }
        
    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
       // print("\(defaults.integerForKey("countdown"))")
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("done")
    }
    
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        
        if let notificationIdentifier = identifier{
            if notificationIdentifier == "fallenButtonPressed"
            {
                self.testMsg()
            }
            else if notificationIdentifier == "dismissButtonPressed"
            {
                print("no I haven't fallen")
            }
        }
    }
    
    deinit {
        print("deinit interface controller")
    }
    
}
