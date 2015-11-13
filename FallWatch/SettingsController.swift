//
//  SettingsController.swift
//  FallWatch
//
//  Created by Andrea Gines on 10/16/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import Foundation
import Contacts
import ContactsUI
import CoreFoundation // required for the communication between phone and watch

//var settingsData = SettingsData()

class SettingsController: UIViewController{
    var textBody = "Default help request"
    var contactNumber = "2484620038"
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var contactText: UITextField!
    @IBOutlet var messageText: UITextField!
    @IBOutlet var addContact: UIButton!
  //  @IBOutlet var textButton: UIButton!
  
    @IBAction func timer(sender: UISlider) {
        print(sender)
        let num = Float(sender.value)
        let val = Int(num)
        timeLabel.text = "\(val)"
        
        //settingsData.setTimer(val)
    }
    
    func notificationCallback(center: CFNotificationCenterRef , observer: UnsafePointer<Void>,  name: CFStringRef, object: UnsafePointer<Void>, userInfo: CFDictionaryRef)->Void {
            print("Callback detected: \(name), \(object)")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let callback: @convention(block)
        (CFNotificationCenter!, UnsafeMutablePointer<Void>, CFString!, UnsafePointer<Void>, CFDictionary!) -> Void = {
            (center, observer, name, object, userInfo) in
            
            print("darwin callback")
            //NSNotificationCenter.defaultCenter().postNotificationName(object: nil,
             //   userInfo: nil)
        }
        /*
        let notificationCallback: CFNotificationCallback = callback
        
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, notificationCallback, nil, nil, CFNotificationSuspensionBehavior.Drop)
*/
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func contactAction(sender: UIButton) {
       /* do {
            let store = CNContactStore()
            
            let groups = try store.groupsMatchingPredicate(nil)
            let filteredGroups = groups.filter { $0.name == "Work" }
            
            guard let workGroup = filteredGroups.first else {
                print("No Work group")
                return
            }
            
            let predicate = CNContact.predicateForContactsInGroupWithIdentifier(workGroup.identifier)
            let keysToFetch = [CNContactGivenNameKey]
            let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
            
            print(contacts)
        }
        catch {
            print("Handle error")
        }*/
    }
    @IBAction func contactEdit(textField: UITextField) {
        contactNumber = contactText.text!
    }
    @IBAction func messageEdit(textField: UITextField) {
        textBody = messageText.text!
    }
    @IBAction func text(sender: AnyObject) {
        // Use your own details here
        let twilioSID = "ACf310bf0b1beb964d15360f0dfc8b317d"
        let twilioSecret = "9a1daecd3a6206463e13259a65001131"
        let fromNumber = "2486483835"
        let toNumber = "2484620038"
        let message = textBody
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
    @IBOutlet weak var textField: UITextField!
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}
