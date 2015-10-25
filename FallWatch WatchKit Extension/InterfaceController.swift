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

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var toggleMonitoringBtn: WKInterfaceButton!
    var monitoringOn = false
    var count = 0
//    let healthStore = HKHealthStore()
//    let workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.Other, locationType: HKWorkoutSessionLocationType.Unknown)
    let accMonitor = FWAcceleration()
    
    func update() {
        timeLabel.setText(String(count++))
    }
    
    @IBAction func toggleMonitoring() {
        
        if monitoringOn == false {
            monitoringOn = true
            print("on")

            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Success)
            
            accMonitor.startMonitoring()
            
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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let defaults = NSUserDefaults.init(suiteName: "group.me.fallwatch.FallWatch.defaults")!
       // print("\(defaults.integerForKey("countdown"))")
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("done")
    }
    
    deinit {
        print("deinit interface controller")
    }
    
}
