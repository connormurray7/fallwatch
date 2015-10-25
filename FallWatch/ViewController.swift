//
//  ViewController.swift
//  FallWatch
//
//  Created by Evan Stoddard on 10/21/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "acknowledgeAlert:", name: "actionOnePressed", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMessage:", name: "actionTwoPressed", object: nil)
        
        let dateComp = NSDateComponents()
        dateComp.year = 2015
        dateComp.month = 10
        dateComp.day = 24
        dateComp.hour = 20
        dateComp.minute = 16
        dateComp.timeZone = NSTimeZone.systemTimeZone()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let date = (calendar!.dateFromComponents(dateComp))!
        
        let notification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = "This is a notification"
        notification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        let defaults = NSUserDefaults.init(suiteName: "group.me.fallwatch.FallWatch.defaults")!
        defaults.setInteger(30, forKey: "countdown")
        defaults.synchronize()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func acknowledgeAlert(notification:NSNotification)
    {
        /*
        let view:UIView = UIView(frame: CGRectMake(100, 100, 100, 100))
        
        view.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(view)
        */
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "A family member has fallen"
        label.textColor = UIColor.redColor()
        self.view.addSubview(label)
        print("handle the case in which people fall")
        
        
        
    }
    
    func showMessage(notification:NSNotification)
    {
        let message:UIAlertController = UIAlertController(title: "A Notification Mesage", message: "You are the primary contact for someone that has fallen", preferredStyle: UIAlertControllerStyle.Alert)
        
        message.addAction(UIAlertAction(title: "2d", style: UIAlertActionStyle.Default, handler: nil))
        
       // self.presentedViewController(message, animated: true, completion: nil)
        self.presentViewController(message, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

