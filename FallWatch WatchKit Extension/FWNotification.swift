//
//  FWNotification.swift
//  FallWatch
//
//  Created by Andrea Gines on 11/3/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//
//  InterfaceController for modally-presented fall notification

import WatchKit
import UIKit

class FWNotification : WKInterfaceController {
    
    @IBOutlet var cancelButton: WKInterfaceButton!
    @IBOutlet var getHelpButton: WKInterfaceButton!
    @IBOutlet var notificationLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!

    private var time = 40
    private var timer = NSTimer()
    private var buttonPressed = false
    
    override init() {
        super.init()
        print("Singleton init FWNotification: time= \(time)")
        
        // hides the cancel button
        setTitle("")
        
        // start countdown
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    @IBAction func notificationDismissed() {
        timer.invalidate()
        
        let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        ic.accMonitor.falseAlarm()
        
        buttonPressed = true
        dismissController()
    }
    
    @IBAction func helpNeeded() {
        timer.invalidate()
        
        let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        ic.accMonitor.trueAlarm()
        
        buttonPressed = true
        dismissController()
    }
    
    func subtractTime() {
        time--
        
        timeLabel.setText("\(time)s")
        print("Time: \(time)")
        
        // play haptic to remind user that time is ticking!
        let hpt = WKInterfaceDevice()
        if time % 2 == 0 {
            hpt.playHaptic(WKHapticType.Stop)
        }
        
        // if user doesn't dismiss alert before countdown expires, fall is legit
        if time == 0 {
            print("User didn't dismiss alert. Fall detected.")
            helpNeeded()
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        print("awakeWithContext FWNotification")
        // configure interface objects here.
        
        let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        time = ic.defaults.integerForKey("timer")
    }
    
    override func willActivate() {
        super.willActivate()
        print("willActivate FWNotification")
        // this method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        print("didDeactivate FWNotification")
        timer.invalidate()
        // this method is called when watch view controller is no longer visible
        
        // treats a press to upper left corner the same as pressing cancel
        if buttonPressed == false {
            notificationDismissed()
        } else {
            buttonPressed = true
        }
    }
}