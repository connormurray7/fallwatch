//
//  File.swift
//  FallWatch
//
//  Created by Connor Murray on 10/11/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import Foundation
import CoreMotion

class FallWatchAcceleration : NSObject {
    //Private Variables
    private var accelerationArray = [Double](count: 8, repeatedValue: 0.0)
    private var flagArray = [Bool](count: 8, repeatedValue: false)
    private let motionManager = CMMotionManager()
    private let recorder = CMSensorRecorder()
    private var timer = NSTimer()
    private let lowNormalRange = -0.2
    private let highNormalRange = 0.2
    private let lowFallingRange = 0.6
    private let highFallingRange = 1.1
    private var foundAFall = false
    private var stillMonitoring = true
    
    //Private Methods
    private func checkNormalRange(idx : Int) -> Bool {
        return (accelerationArray[idx] < highNormalRange && accelerationArray[idx] > lowNormalRange) ? true : false
    }
    private func checkFallingRange(idx : Int) -> Bool {
        return (accelerationArray[idx] < highFallingRange && accelerationArray[idx] > lowFallingRange) ? true : false
    }
    private func checkFlags() -> Bool { //only called once a value is pushed, so checks the flag values...
        for(var i = 0; i < 4; ++i) {
            foundAFall = true
            if(i < 4) {
                flagArray[i] = checkNormalRange(i) ? true : false
            }
            else if(i < 6 && i >= 4) {
                flagArray[i] = checkFallingRange(i) ? true : false
            }
            else {
                flagArray[i] = checkNormalRange(i) ? true : false
            }
            if(flagArray[i] == false) { foundAFall = false }
        }
        return foundAFall
    }
    
    func startMonitoring() {
        print("Accelerometer active: \(motionManager.accelerometerActive)")
        assert(motionManager.accelerometerAvailable, "Accelerometer not available on this device!")
        if(!motionManager.accelerometerActive) {
            motionManager.startAccelerometerUpdates()
            //motionManager.accelerometerUpdateInterval = 1/10
        }
        stillMonitoring = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: Selector("pushValue:"), userInfo: nil, repeats: stillMonitoring)
    }
    
    func stopMonitoring() {
        if(motionManager.accelerometerActive) {
            motionManager.stopAccelerometerUpdates()
            stillMonitoring = false;
        }
    }
    
    //Public Funtions
    func pushValue(timer:NSTimer) {
        print("Accelerometer active: \(motionManager.accelerometerActive)")
        let a = motionManager.accelerometerData?.acceleration
        //        print(motionManager.accelerometerData?.acceleration.x)
        //        print(motionManager.accelerometerData?.acceleration.y)
        //        print(motionManager.accelerometerData?.acceleration.z)
        accelerationArray.rotate(1)
        flagArray.rotate(1)
        // magnitude of acceleration formula
        accelerationArray[0] = sqrt(a!.x*a!.x + a!.y*a!.y + a!.z*a!.z)
        if(checkFlags()) {
            print("fall detected")
            return; //This would be to send a message to another part of the program
        }
    }
}
extension Array {
    func rotate(shift:Int) -> Array {
        var array = Array()
        if (self.count > 0) {
            array = self
            if (shift > 0) {
                for _ in 1...shift {
                    array.append(array.removeAtIndex(0))
                }
            }
            else if (shift < 0) {
                for _ in 1...abs(shift) {
                    array.insert(array.removeAtIndex(array.count-1),atIndex:0)
                }
            }
        }
        return array
    }
}