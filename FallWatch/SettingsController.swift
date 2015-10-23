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
    
    @IBOutlet weak var textField: UITextField!
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}
