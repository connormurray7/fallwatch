//
//  SettingsController.swift
//  FallWatch
//
//  Created by Andrea Gines on 10/16/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import Foundation

var settingsData = SettingsData()

class SettingsController: UIViewController {
    
    @IBOutlet var timeLabel: UILabel!
  //  @IBOutlet var textButton: UIButton!
  
    @IBAction func timer(sender: UISlider) {
        //print(sender)
        let num = Float(sender.value)
        let val = Int(num)
        timeLabel.text = "\(val)"
        
        settingsData.setTimer(val)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func text(sender: AnyObject) {
        print("hello")
        // Use your own details here
        let twilioSID = "ACf310bf0b1beb964d15360f0dfc8b317d"
        let twilioSecret = "9a1daecd3a6206463e13259a65001131"
        let fromNumber = "2486483835"
        let toNumber = "2484620038"
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
    //@IBAction func sendText(sender: UIButton) {
    /*    print("Tapped button")
        // Use your own details here
        let twilioSID = "ACf310bf0b1beb964d15360f0dfc8b317d"
        let twilioSecret = "9a1daecd3a6206463e13259a65001131"
        let fromNumber = "2486483835"
        let toNumber = "2484620038"
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
*/
   // }
    @IBOutlet weak var textField: UITextField!
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}
