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

class FWNotification {
    
    static let sharedInstance = FWNotification()
    
    private var time = 40
    private var seconds = 0
    private var timer = NSTimer()
    
    init() {
        print("Singleton init: time= \(time)")
    }
    
    // returns true if the user dismisses the alert, else notifies the user's emergency contacts and returns false
    func didUserDismissAlert() ->Bool{
        
        let icSelfPtr = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
       
        icSelfPtr.fireNotification()
        
        seconds = time
        timer = NSTimer()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: icSelfPtr, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        if seconds == 0 {
//            icSelfPtr.testMsg()
        }
        //assert timer should never be < than 0
        return seconds != 0; // the user dismissed the alert before it reached 0
        
    }
    func subtractTime() {
        seconds--
        print("Time: \(seconds)")
        
        if(seconds == 0)  {
            timer.invalidate()
        }
    }
    func notificationDismissed()
    {
        //invalidate timer and return false
        timer.invalidate()
    }
    
    func setTimer(FWTime: Int)
    {
        
        // assert illegal time
        time = FWTime
        print("New timer value= \(time)")
    }
    
    
}
/*
var seconds = 0
var timer = NSTimer()
func startCountDown()
{
    let icSelfPtr = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: icSelfPtr, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
}
func subtractTime() {
    seconds--
    print("Time: \(seconds)")
    
    if(seconds == 0)  {
        timer.invalidate()
    }
}
*/