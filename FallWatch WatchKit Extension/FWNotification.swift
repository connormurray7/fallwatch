//
//  FWNotification.swift
//  FallWatch
//
//  Created by Andrea Gines on 11/3/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import Foundation
import WatchKit
import UIKit

class FWNotification : NSObject {
    
    static let sharedInstance = FWNotification()
    private var time = 40
    private var seconds = 0
    private var timer = NSTimer()
    private let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
    
    override init() {
        print("Singleton init FWNotification: time= \(time)")
    }
    
    func invalidateTimer() {
        timer.invalidate()
    }
    
    func setTimer(FWTime: Int) {
        time = FWTime
        print("New timer value= \(time)")
    }
    
    func notificationDismissed() {
        timer.invalidate()
        ic.accMonitor.falseAlarm()
    }
    
    func helpNeeded() {
        timer.invalidate()
        ic.accMonitor.trueAlarm()
    }
    
    func subtractTime() {
        seconds--
        print("Time: \(seconds)")
        
//        let hpt = WKInterfaceDevice()
//        if(seconds % 2 == 0) {
//            hpt.playHaptic(WKHapticType.Failure)
//        } else {
//            hpt.playHaptic(WKHapticType.Retry)
//        }
        
        // if user doesn't dismiss alert, fall is legit
        if seconds == 0 {
            print("User didn't dismiss alert. Fall detected.")
            helpNeeded()
        }
    }
    
    func didUserDismissAlert() {
        // create and send UILocalNotification to iPhone for scheduling
        fireNotification()
        seconds = time
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        print("didUserDismissAlert")
    }
    
    func fireNotification() {
        
        let dict = ["fireNotification": "notify"]
        
//        do {
//            print("Fire Local Notification")
        ic.session!.sendMessage(dict, replyHandler: nil, errorHandler: {(error) -> Void in print("error") })
//        } catch {
//            print("error")
//        }
    }
}
