//
//  FWAcceleration.swift
//  FallWatch
//
//  Created by Connor Murray on 10/11/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import CoreMotion

class FWAcceleration : NSObject {

    private var accelerationArray = [Double](count: 60, repeatedValue: 0.0)
    private var flagArray = [Bool](count: 60, repeatedValue: false)
    private var logging = false;
    private var foundAFall = false
    private var stillMonitoring = true
    private var timer = NSTimer()
    var helpNeeded = false
    
    private let motionManager = CMMotionManager()
    private let lowNormalRange = 0.0
    private let highNormalRange = 2.0
    private let lowFallingRange = 3.0
    private let highFallingRange = 5.5

    // assumes that the acceleration array is populated at the specific index. Returns true if the value falls within the normal range

    private func checkNormalRange(idx : Int) -> Bool {
        return (accelerationArray[idx] <= highNormalRange && accelerationArray[idx] >= lowNormalRange) ? true : false
    }

    // assumes that the acceleration array is populated at the specific index. Returns true if the value falls within the falling range

    private func checkFallingRange(idx : Int) -> Bool {
        return (accelerationArray[idx] < highFallingRange && accelerationArray[idx] > lowFallingRange) ? true : false
    }
    
    // allows for logging
    
    private func log() {
        print(NSDate().timeIntervalSince1970*1000)
        print(motionManager.accelerometerData?.acceleration.x)
        print(motionManager.accelerometerData?.acceleration.y)
        print(motionManager.accelerometerData?.acceleration.z)
    }
    
    func startMonitoring() {

        assert(motionManager.accelerometerAvailable, "Accelerometer not available on this device!")
        
        if(!motionManager.accelerometerActive) {
            motionManager.startAccelerometerUpdates()
            // set the intervals to 20 Hz
            motionManager.deviceMotionUpdateInterval = 0.05
            motionManager.accelerometerUpdateInterval = 0.05
        }
        
        stillMonitoring = true
        timer = NSTimer.scheduledTimerWithTimeInterval(1/20, target:self,
            selector: Selector("pushValue:"), userInfo: nil, repeats: stillMonitoring)
    }


    func stopMonitoring() {
        
        if(motionManager.accelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
        
        timer.invalidate()
        stillMonitoring = false;
        
        // clear array
        for var i = accelerationArray.count - 1; i >= 0; --i {
            accelerationArray[i] =  0.0
        }
    }

    // checks the entire array to see if enough variables fall within the falling and still ranges. Returns true if the value falls within the falling range

    private func checkFlags() -> Bool {
        
        var normalMag = 0
        var highMag = 0
        foundAFall = false
        
        for(var i = 0; i < 60; ++i) {
            
            // only checks for stillness in most recent 1.5 seconds
            if(i < 30 && checkNormalRange(i)) {
                normalMag++
            }
            // only checks for falls greater than 1.5 seconds ago
            else if(i >= 30 && checkFallingRange(i)) {
                highMag++
            }
        }
        
        // if enough values are in the ranges, then a fall was found
        return ((normalMag == 30 && highMag >= 1) ? true : false)
    }

    // this functions rotates the acceleration array and adds the new value from the acceleromter. It then checks the flags to see if there was a fall.
    
    func trueAlarm() {
        print("True Alarm")
        helpNeeded = true
        
        // play failure haptic feedback
        let hpt = WKInterfaceDevice()
        hpt.playHaptic(WKHapticType.Failure)
        
        // send text/get help
        let message = ["needsHelp" : true]
        let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        ic.session?.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    // resume monitoring
    func falseAlarm() {
        print("False Alarm")
        
        let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        ic.enableMonitoring = true
    }
    
    func pushValue(timer: NSTimer) {
        
        let a = motionManager.accelerometerData?.acceleration

        accelerationArray.rotate()
        
        // magnitude of acceleration
        accelerationArray[0] = sqrt(a!.x*a!.x + a!.y*a!.y + a!.z*a!.z)
        
        // fall detected
        if checkFlags() {
            print("fall detected")
            
            // temporarily stop monitoring
            let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
            ic.toggleMonitoring()
            ic.presentControllerWithName("FWNotification", context: nil)
        }
    }
}

extension Array {
    mutating func rotate() -> Void {
        for var i = self.count - 1; i > 0; --i {
            self[i] = self[i-1]
        }
    }
}
