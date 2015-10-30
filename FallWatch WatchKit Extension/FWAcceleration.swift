
//  File.swift
//  FallWatch
//
//  Created by Connor Murray on 10/11/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class FWAcceleration : NSObject {
    
    // private Variables
    private var accelerationArray = [Double](count: 60, repeatedValue: 0.0)
    private var flagArray = [Bool](count: 60, repeatedValue: false)
    private let motionManager = CMMotionManager()
    private var timer = NSTimer()
    //private var hapticTimer = NSTimer()
    private let lowNormalRange = 0.7
    private let highNormalRange = 1.3
    private let lowFallingRange = 2.3
    private let highFallingRange = 5.5
    private var foundAFall = false
    private var stillMonitoring = true
//    var ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
    
    // private Methods
    private func checkNormalRange(idx : Int) -> Bool {
        return (accelerationArray[idx] <= highNormalRange && accelerationArray[idx] >= lowNormalRange) ? true : false
    }
    
    private func checkFallingRange(idx : Int) -> Bool {
        return (accelerationArray[idx] < highFallingRange && accelerationArray[idx] > lowFallingRange) ? true : false
    }
    
    // only called once a value is pushed, so checks the flag values...
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
        return ((normalMag == 30 && highMag >= 1) ? true : false)
    }
    
    func startMonitoring() {
        
//        print("Accelerometer active: \(motionManager.accelerometerActive)")
        assert(motionManager.accelerometerAvailable, "Accelerometer not available on this device!")
        
        if(!motionManager.accelerometerActive) {
            motionManager.startAccelerometerUpdates()
            motionManager.deviceMotionUpdateInterval = 0.05
            motionManager.accelerometerUpdateInterval = 0.05
        }
        
        stillMonitoring = true
        timer = NSTimer.scheduledTimerWithTimeInterval(1/20, target:self, selector: Selector("pushValue:"), userInfo: nil, repeats: stillMonitoring)
    }
    
    func stopMonitoring() {
        
        if(motionManager.accelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
        
        //ic.toggleMonitoring()
        
        timer.invalidate()
        stillMonitoring = false;
    }

    func pushValue(timer: NSTimer) {
//        print("Accelerometer active: \(motionManager.accelerometerActive)")
        
        let a = motionManager.accelerometerData?.acceleration
//        print(motionManager.accelerometerData?.acceleration.x)
//        print(motionManager.accelerometerData?.acceleration.y)
//        print(motionManager.accelerometerData?.acceleration.z)
        accelerationArray.rotate()
        //flagArray.rotate(1)
        
        // magnitude of acceleration formula
        accelerationArray[0] = sqrt(a!.x*a!.x + a!.y*a!.y + a!.z*a!.z)
        print(accelerationArray[0])
        
        // fall detected
        if(checkFlags()) {
            print("fall detected")
            timer.invalidate()
            
            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Failure)
            let ic = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
            ic.toggleMonitoring()

            //InterfaceController.toggleMonitoring(xtension.rootInterfaceController as! InterfaceController)
//            xtension.rootInterfaceController as! InterfaceController.toggleMonitoring;()
            
//            InterfaceController.
//            ExtensionDelegate.in


//            hapticTimer = NSTimer.sched
//            haptictimer = NSTimer.scheduledTimerWithTimeInterval(1/10, target:self, selector: Selector("pushValue:"), userInfo: nil, repeats: true)
            
//            accelerationArray.removeAll(keepCapacity: true)
            
            for var i = accelerationArray.count - 1; i >= 0; --i {
                accelerationArray[i] =  0.0
            }
            
            return;
        }
    }
}

extension Array {
    mutating func rotate() -> Void {
        for var i = self.count - 1; i > 0; --i {
            self[i] = self[i-1]
        }
    }
    
//    mutating func clear() -> Void {
//        for var i = self.count - 1; i >= 0; --i {
//            self[i] =  self[i - 1]
//            self.removeAll(keepCapacity: <#T##Bool#>)
//        }
//    }
}
