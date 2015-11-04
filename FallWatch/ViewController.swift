//
//  ViewController.swift
//  FallWatch
//
//  Created by Evan Stoddard on 10/21/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import UIKit
import Foundation
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet weak var alert: UILabel!
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureWCSession()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureWCSession()
    }
    
    private func configureWCSession() {
        session?.delegate = self;
        session?.activateSession()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "acknowledgeAlert:", name: "actionOnePressed", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMessage:", name: "actionTwoPressed", object: nil)
        
        let dateComp = NSDateComponents()
        dateComp.year = 2015
        dateComp.month = 10
        dateComp.day = 25
        dateComp.hour = 15
        dateComp.minute = 52 // when simulating modify hour/minute/day/month
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
        AppDelegate.sharedDelegate().checkAccessStatus({ (accessGranted) -> Void in
            print(accessGranted)
        })

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
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let alert = applicationContext["alert"] as? String
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            if let alert = alert {
                self.alert.text = "Did someone fall? \(alert)"
                self.textContact()
            }
        }
    }
    func textContact()
    {
        print("TEXT CONTACT")
        // Use your own details here
        let twilioSID = "ACf310bf0b1beb964d15360f0dfc8b317d"
        let twilioSecret = "9a1daecd3a6206463e13259a65001131"
        let fromNumber = "2486483835"
        let toNumber = "2484620038"
        //let message = textBody
        let message = "Yo I fell please help me"
        // Build the request
        let request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Build the completion block and send the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()

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

