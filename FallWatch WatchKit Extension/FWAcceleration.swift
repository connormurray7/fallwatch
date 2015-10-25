//
//  File.swift
//  FallWatch
//
//  Created by Connor Murray on 10/11/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import Foundation
import CoreMotion

class FWAcceleration : NSObject {
    
    // private Variables
    private var accelerationArray = [Double](count: 30, repeatedValue: 0.0)
    private var flagArray = [Bool](count: 30, repeatedValue: false)
    private let motionManager = CMMotionManager()
    private var timer = NSTimer()
    private let lowNormalRange = 0.8
    private let highNormalRange = 1.2
    private let lowFallingRange = -0.2
    private let highFallingRange = 0.6
    private var foundAFall = false
    private var stillMonitoring = true
    
    // private Methods
    private func checkNormalRange(idx : Int) -> Bool {
        return (accelerationArray[idx] <= highNormalRange && accelerationArray[idx] >= lowNormalRange) ? true : false
    }
    
    private func checkFallingRange(idx : Int) -> Bool {
        return (accelerationArray[idx] < highFallingRange && accelerationArray[idx] > lowFallingRange) ? true : false
    }
    
    // only called once a value is pushed, so checks the flag values...
    private func checkFlags() -> Bool {
        
        for(var i = 0; i < 4; ++i) {
            
            foundAFall = true
            
            if(i < 20) {
                flagArray[i] = checkNormalRange(i) ? true : false
            }
            else if(i < 25 && i >= 20) {
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
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.accelerometerUpdateInterval = 0.1
        }
        
        stillMonitoring = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector: Selector("pushValue:"), userInfo: nil, repeats: stillMonitoring)
    }
    
    func stopMonitoring() {
        
        if(motionManager.accelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
        
        timer.invalidate()
        stillMonitoring = false;
    }

    func pushValue(timer: NSTimer) {
        print("Accelerometer active: \(motionManager.accelerometerActive)")
        
        let a = motionManager.accelerometerData?.acceleration
        print(motionManager.accelerometerData?.acceleration.x)
        print(motionManager.accelerometerData?.acceleration.y)
        print(motionManager.accelerometerData?.acceleration.z)
        accelerationArray.rotate(1)
        flagArray.rotate(1)
        
        // magnitude of acceleration formula
        accelerationArray[0] = sqrt(a!.x*a!.x + a!.y*a!.y + a!.z*a!.z)
        
        // fall detected
        if(checkFlags()) {
            print("fall detected")
            return;
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