//
//  InterfaceController.swift
//  FallWatch WatchKit Extension
//
//  Created by Evan Stoddard on 10/4/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var messageSentLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var toggleMonitoringBtn: WKInterfaceButton!
    
    var monitoringOn = false
    var count = 0
    var seconds = 0
    var enableMonitoring = false
    var contacts = 0

    let accMonitor = FWAcceleration()
    let defaults = NSUserDefaults(suiteName: "group.me.fallwatch.FallWatch.defaults")!
    let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        session?.delegate = self
        session?.activateSession()
        print("init InterfaceController")
        
        contacts = defaults.integerForKey("contacts")
        
    }
    
    @IBAction func toggleMonitoring() {
        
        if contacts == 0{
            print("user hasn't added emergency contacts yet")
            return
        }
        
        if monitoringOn == false {
            print("toggle monitoring on")
            monitoringOn = true
            messageSentLabel.setText("")
            
            // play haptic to signal monitoring has started
            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Start)

            accMonitor.startMonitoring()
            
            // interface updates
            toggleMonitoringBtn.setBackgroundColor(UIColor.redColor())
            toggleMonitoringBtn.setTitle("STOP Monitoring")
            statusLabel.setTextColor(UIColor.greenColor())
            statusLabel.setText("Monitoring On")
        } else {
            monitoringOn = false
            print("toggle monitoring off")
            
            // play haptic to signal monitoring has ended
            let hpt = WKInterfaceDevice()
            hpt.playHaptic(WKHapticType.Stop)
            
            accMonitor.stopMonitoring()
            
            // interface updates
            toggleMonitoringBtn.setBackgroundColor(UIColor.greenColor())
            toggleMonitoringBtn.setTitle("START Monitoring")
            statusLabel.setTextColor(UIColor.redColor())
            statusLabel.setText("Monitoring Off")
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        // use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            let settingsContext = applicationContext as! [String : Int]
            if let timer = settingsContext["timer"] {
                self.defaults.setInteger(timer, forKey: "timer")
                self.defaults.synchronize()
                
            }
            
            if let numContacts = settingsContext["contacts"] {
                self.defaults.setInteger(numContacts, forKey: "contacts")
                self.defaults.synchronize()
            }
            print("SetTime: \(settingsContext["timer"])")
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        print("awakeWithContext InterfaceController")
        // configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()
        print("willActivate InterfaceController")
        // this method is called when watch view controller is about to be visible to user
        
        // update inteface to reflect that message was sent
        if accMonitor.helpNeeded == true {
            messageSentLabel.setText("Message Sent")
            accMonitor.helpNeeded = false
        } else {
            messageSentLabel.setText("")
        }
        
        // if monitoring needs to be enabled after a false alarm, toggle it on
        if enableMonitoring == true {
            toggleMonitoring()
            enableMonitoring = false
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        print("didDeactivate InterfaceController")
        // this method is called when watch view controller is no longer visible
    }
    
    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
        let fromComplication = ["fromComplication" : true]
        presentControllerWithName("FWNotification", context: fromComplication)
    }
}
