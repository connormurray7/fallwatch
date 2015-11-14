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
    // let healthStore = HKHealthStore()
    // let workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.Other, locationType: HKWorkoutSessionLocationType.Unknown)
    let accMonitor = FWAcceleration()
    let defaults = NSUserDefaults.init(suiteName: "group.me.fallwatch.FallWatch.defaults")!
    //let note = NotificationController()
    var timer: NSTimer?
    var seconds = 0
    // connect watch to iphone
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }

    func update() {
        timeLabel.setText(String(count++))
    }
    func timerDidFire(timer: NSTimer)
    {
        --seconds
        print("timerDidFire")
        print(timer)
        print(seconds)
        if seconds == 0
        {
            timer.invalidate()
        }
    }
    
    @IBAction func toggleMonitoring() {
        
        if monitoringOn == false {
            monitoringOn = true
            //note.didReceiveLocalNotification(<#T##localNotification: UILocalNotification##UILocalNotification#>, withCompletion: <#T##((WKUserNotificationInterfaceType) -> Void)##((WKUserNotificationInterfaceType) -> Void)##(WKUserNotificationInterfaceType) -> Void#>)
            
            //let myTimer = NSTimer(timeInterval: 1.0, target: self, selector: "timerDidFire:", userInfo: nil, repeats: true)
            //NSRunLoop.currentRunLoop().addTimer(myTimer, forMode: NSRunLoopCommonModes)
            
            // play haptic to signal monitoring has started
            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Start)
            
            
            
            // testMsg();
            accMonitor.startMonitoring()
            // healthStore.startWorkoutSession(workoutSession)
            
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
    
    func fireNotification() {
        let notification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = "Send from FWNotification"
        //notification.fireDate = date
        notification.alertTitle = "User has fallen"
        let dict = ["fireNotification": notification]
        do {
            print("Fire Local Notification")
            try self.session?.updateApplicationContext(dict)
        } catch {
            print("error")
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let data = applicationContext["timer"] as? Int
        
        // use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            if let value = data {
                
                FWNotification.sharedInstance.setTimer(value);
                //self.statusLabel.setText("timer \(value)")
                
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("willActivate")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("didDeactivate")
    }
    
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        
        if let notificationIdentifier = identifier{
            
            if notificationIdentifier == "fallenButtonPressed"
            {
                // notify user's contacts immmidiately
            }
            else if notificationIdentifier == "dismissButtonPressed"
            {
                print("no I haven't fallen")
                notificationDismissed()
            }
        }
        
    }
    
    func notificationDismissed()
    {
        //invalidate timer and return false
        timer!.invalidate()
        timer = nil
    }

    func subtractTime() {
        seconds--
        print("Time: \(seconds)")
        
        if(seconds == 0)  {
            timer!.invalidate()
            timer = nil
        }
    }
    
    func didUserDismissAlert() ->Bool{
        fireNotification()
        seconds = FWNotification.sharedInstance.getTimer()
        //timer = NSTimer()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        
        if seconds == 0 {
            //            icSelfPtr.testMsg()
            // notify user contacts via text msg
           
        }
        
        //assert timer should never be < than 0
        return seconds != 0; // the user dismissed the alert before it reached 0
        
    }
    
    
    
}
