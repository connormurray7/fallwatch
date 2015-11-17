//
//  FWNotification.swift
//  FallWatch
//
//  Created by Andrea Gines on 11/3/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import UIKit

class FWNotification : WKInterfaceController {
    
    @IBOutlet var cancelButton: WKInterfaceButton!
    @IBOutlet var getHelpButton: WKInterfaceButton!
    @IBOutlet var notificationLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!

    private var time = 40
    private var seconds = 0
    private var timer = NSTimer()
    
    override init() {
        super.init()
        print("Singleton init FWNotification: time= \(time)")
        seconds = time
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    @IBAction func notificationDismissed() {
        timer.invalidate()
        let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        dismissController()
        ic.accMonitor.falseAlarm()
    }
    
    @IBAction func helpNeeded() {
        timer.invalidate()
        let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        ic.accMonitor.trueAlarm()
        dismissController()
    }
    func setTime(time_in : Int) {
        time = time_in;
    }
    
    func subtractTime() {
        seconds--
        timeLabel.setText("\(seconds)s")
        print("Time: \(seconds)")
        
        let hpt = WKInterfaceDevice()
//        if seconds % 4 == 0 {
//            hpt.playHaptic(WKHapticType.Failure)
//        } else 
        if seconds % 2 == 0 {
            hpt.playHaptic(WKHapticType.Stop)
        }
        
        // if user doesn't dismiss alert, fall is legit
        if seconds == 0 {
            print("User didn't dismiss alert. Fall detected.")
            helpNeeded()
        }
    }
}