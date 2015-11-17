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
import Contacts
import ContactsUI
protocol ViewControllerDelegate {
    func didFetchContacts(contacts: [CNContact])
}
//var settingsData = SettingsData()

class ViewController: UIViewController, WCSessionDelegate, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, CNContactPickerDelegate//, UITableViewDataSource
{
    var textBody = "Default help request"
    var contactNumber = "2484620038"
    var contacts = [CNContact]()
    var delegate: ViewControllerDelegate!
    @IBOutlet weak var timerSegment: UISegmentedControl!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var messageText: UITextField!
    @IBOutlet var addContact: UIBarButtonItem!
    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!

    
    @IBAction func timer(sender: UISlider) {
        print(sender)
        let num = Float(sender.value)
        let val = Int(num)
        timeLabel.text = "\(val)"
        
        //settingsData.setTimer(val)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let swiftColor = UIColor(red: 1, green: 80/255, blue: 80/255, alpha: 1)

        self.view.backgroundColor = swiftColor
        
        self.contactView.layer.borderWidth = 1
        self.contactView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        self.messageView.layer.borderWidth = 1
        self.messageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor

        
        self.timerSegment.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "acknowledgeAlert:", name: "actionOnePressed", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMessage:", name: "actionTwoPressed", object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let dateComp = NSDateComponents()
        dateComp.year = 2015
        dateComp.month = 10
        dateComp.day = 25
        dateComp.hour = 15
        dateComp.minute = 52 // when simulating modify hour/minute/day/month
        dateComp.timeZone = NSTimeZone.systemTimeZone()
        timerSegment.layer.cornerRadius = 5.0
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



    @IBAction func showContacts(sender: AnyObject) {
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "firstName != nil")
        
        contactPickerViewController.delegate = self
        
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    @IBOutlet var messageEdit: UITextField!
    @IBAction func messageEdit(sender: AnyObject) {
        textBody = messageText.text!
    }
    @IBAction func text(sender: AnyObject) {
        // Use your own details here
        let twilioSID = "ACf310bf0b1beb964d15360f0dfc8b317d"
        let twilioSecret = "9a1daecd3a6206463e13259a65001131"
        let fromNumber = "2486483835"
        let toNumber = "2484620038"
        let message = messageTextView.text
        //let message = "Yo I fell please help me"
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
        print("session ViewController")
        let alert = applicationContext["alert"] as? String
        let localNotification = applicationContext["fireNotification"] as? String
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            if let alert = alert {
                self.alert.text = "Current Status: \(alert)"
                self.textContact()
                
            } else if let notification = localNotification{
                
                print("local notification should fire soon")
                let notification = UILocalNotification()
                notification.category = "FIRST_CATEGORY"
                notification.alertBody = "Send from FWNotification"
                notification.alertTitle = "User has fallen"
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
        }
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        let message = messageTextView.text        // Build the request
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
    
    @IBAction func segmentPressed(sender: UISegmentedControl) {
        
        var selection = 20
        switch sender.selectedSegmentIndex
        {
            case 0:
                selection = 20
            case 1:
                selection = 40
            case 2:
                selection = 60
            default:
                break
            
        }
        print(selection)
        SettingsData.sharedInstance.setTimer(selection)
        let dict = ["timer": selection]
        sendWatchTimerAndContactInfo(dict)
        
        
    }
    
    func sendWatchTimerAndContactInfo(settingsData: [String : AnyObject])
    {
        print("sendind info to watch")
        
        do {
            print("Send alert")
            try self.session?.updateApplicationContext(settingsData)
        } catch {
            print("error")
        }
        
    }
    


}

