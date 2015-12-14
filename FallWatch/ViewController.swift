//
//  ViewController.swift
//  FallWatch
//
//  Created by Evan Stoddard on 10/21/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

//import HealthKit
import UIKit
import Foundation
import WatchConnectivity
import Contacts
import ContactsUI
import CoreLocation


class ViewController: UIViewController, WCSessionDelegate, UITableViewDelegate, CNContactPickerDelegate,
    UITableViewDataSource, CLLocationManagerDelegate, UITextViewDelegate
{
    var textBody = "Default help request"
    var contacts = [CNContact]()
    var locationManager = CLLocationManager()

    var defaults: NSUserDefaults = NSUserDefaults.init(suiteName: "group.me.fallwatch.FallWatch.defaults")!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var timerSegment: UISegmentedControl!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var messageText: UITextField!
    @IBOutlet var addContact: UIBarButtonItem!
    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet var messageEdit: UITextField!
    @IBOutlet weak var alert: UILabel!
    @IBOutlet weak var segmentLabel: UISegmentedControl!
    
    @IBOutlet weak var showContactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.returnKeyType = UIReturnKeyType.Done
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        sendButton.hidden = true
        print(contacts.count)
        messageTextView.delegate = self
        
        
        let swiftColor = UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1)
        self.view.backgroundColor = swiftColor
        
        self.contactView.layer.borderWidth = 1
        self.contactView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        self.messageView.layer.borderWidth = 1
        self.messageView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
        messageTextView.text = "Hello," + NSUserName() + "has fallen"
        self.timerSegment.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "acknowledgeAlert:", name: "actionOnePressed", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMessage:", name: "actionTwoPressed", object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        timerSegment.layer.cornerRadius = 5.0
        
        // this highlights the correct time segment (20 s, 40 s, 60 s) selected by the user the last time he used the app, in order to restore previous state, the default time if 20 s the very first time the app is run
        let index:Int = defaults.integerForKey("segmentIndex")
        segmentLabel.selectedSegmentIndex = index
        // the very first time the app is run a call to defaults.integerForKey("countdown") will return 0, becasue you haven't stored any value for that key yet, that is why the check time == 0 is necessary
        var time:Int = defaults.integerForKey("countdown")
        if time == 0 {
            time = 20
        }
        var dict = ["timer": time]
        // the very first time the user runs the app a call to NSUserDefaults.standardUserDefaults().objectForKey("contacts") willl return nil that is why the check recoverContacts != nil is necessary, if recoverContacts != nil then you update the contacts array to reflect prevoiusly saved contacts
        let recoverContacts = NSUserDefaults.standardUserDefaults().objectForKey("contacts")
        if recoverContacts != nil{
            let savedContacts = NSKeyedUnarchiver.unarchiveObjectWithData(recoverContacts as! NSData)
            contacts = savedContacts as! [CNContact]
            
        }
        
        dict["contacts"] = contacts.count
        sendWatchTimerAndContactInfo(dict)
        
        if contacts.count == 0 {
            showContactButton.sendActionsForControlEvents(.TouchUpInside)
        }
       AppDelegate.sharedDelegate().checkAccessStatus({ (accessGranted) -> Void in
            print(accessGranted)
        })
        configureTableView()
    }
    #if ios
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    }
    #endif
    #if os (watchOS)
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject])  {    }
    #endif
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Functions for selecting/adding contacts
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func configureTableView() {
        tblContacts.delegate = self
        tblContacts.dataSource = self
        tblContacts.registerNib(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "idCellContact")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellContact") as! ContactCell
       
        let currentContact = contacts[indexPath.row]
        
        cell.lblFullname.text = "\(currentContact.givenName) \(currentContact.familyName)"
        
        return cell
    }
    
    func saveContacts() -> Void{
        var dataSave:NSData = NSKeyedArchiver.archivedDataWithRootObject(contacts)
        NSUserDefaults.standardUserDefaults().setObject(dataSave, forKey: "contacts")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        sendWatchTimerAndContactInfo(["contacts": self.contacts.count])
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            contacts.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        print(contacts.count)
        self.saveContacts()
        if (contacts.count == 0) {
            showContactButton.sendActionsForControlEvents(.TouchUpInside)
        }
        
    }

    func didFetchContacts(contacts: [CNContact]) {
        
        for contact in contacts {
            self.contacts.append(contact)
            
            print(contact.givenName)
        }
        // save all the contacts to NSUserDefaults
        self.saveContacts()
        tblContacts.reloadData()
    }
    
    @IBAction func showContacts(sender: AnyObject) {
        print("in showContacts function \(sender)")
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format:  "phoneNumbers.@count > 0")
        contactPickerViewController.predicateForSelectionOfProperty =
            NSPredicate(format: "key == 'phoneNumbers'", argumentArray: nil)
        
        contactPickerViewController.delegate = self
        
        self.presentViewController(contactPickerViewController, animated: true, completion: nil)
        
    }
    func contactPicker(picker: CNContactPickerViewController,
        didSelectContacts contacts: [CNContact]) {
            didFetchContacts(contacts)
    }
    
    //allows multiple selection mixed with contactPicker:didSelectContacts:
    func example5(){
        let controller = CNContactPickerViewController()
        
        controller.delegate = self
        
        controller.predicateForEnablingContact =
            NSPredicate(format:
                "phoneNumbers.@count > 0",
                argumentArray: nil)
        
        controller.predicateForSelectionOfProperty =
            NSPredicate(format: "key == 'phoneNumbers'", argumentArray: nil)
        
        navigationController?.presentViewController(controller,
            animated: true, completion: nil)
    }
    
    @IBAction func messageEdit(sender: AnyObject) {
        textBody = messageText.text!
    }
    
    //Request Twilio to send text message to each contacts
    @IBAction func text() {
        // Use your own details here
        for contact in contacts {
            let contactDetails = contact.phoneNumbers[0].value as! CNPhoneNumber
            let toNumber = contactDetails.stringValue
            let twilioSID = "ACf310bf0b1beb964d15360f0dfc8b317d"
            let twilioSecret = "9a1daecd3a6206463e13259a65001131"
            let fromNumber = "2486483835"
           
            var lat = String(locationManager.location!.coordinate.latitude)
            var long = String(locationManager.location!.coordinate.longitude)
            
            var googleMaps = "https://www.google.com/maps/@" + lat + ","+long + ",13z"
            if lat == ""{
                googleMaps = ""
            }
            
            let message = "Hello " + contact.givenName + " " + messageTextView.text + " " + googleMaps
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
            }).resume()}
        
    }
    
    //Functions for connecting watch/phone, sending timer info, triggering text messages.
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("initializing wcsession")
        configureWCSession()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureWCSession()
        
    }
    
    private func configureWCSession() {
        session?.delegate = self
        session?.activateSession()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("session ViewController")
        let localNotification = message["fireNotification"] as? String
        if localNotification != nil {
            print("local notification should fire soon")
            let notification = UILocalNotification()
            notification.category = "FIRST_CATEGORY"
            notification.alertBody = "Sending SMS in 40s"
            notification.alertTitle = "Fall Detected"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("session ViewController")
        let helpNeeded = applicationContext["needsHelp"] as! Bool
        if helpNeeded == true {
            // send text msg to emergency contact
            text()
        }
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func acknowledgeAlert(notification:NSNotification)
    {
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
        
        
        self.presentViewController(message, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentPressed(sender: UISegmentedControl) {
        
        var selection = 20
        var index = 0
        switch sender.selectedSegmentIndex
        {
        case 0:
            selection = 20
            index = 0
        case 1:
            selection = 40
            index = 1
        case 2:
            selection = 60
            index = 2
        default:
            break
            
        }
        
        defaults.setInteger(selection, forKey: "countdown")
        defaults.setInteger(index, forKey: "segmentIndex")
        defaults.synchronize()
        let dict = ["timer": selection]
        sendWatchTimerAndContactInfo(dict)
    }
    
    func sendWatchTimerAndContactInfo(settingsData: [String : AnyObject]) {
        print("sending info to watch")
      
        do {
            print("Send alert")
            try self.session?.updateApplicationContext(settingsData)
        } catch {
            print("error")
        }
        
    }
    
    
    
}

