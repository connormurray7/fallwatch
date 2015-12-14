//
//  AlertRequirement.swift
//  FallWatch
//
//  Created by Andrea Gines on 12/9/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import UIKit

// View controller class that manages the view that appears when the user tries to press the Start Monitoring button and hasn't added emergency contacts yet
class AlertRequirement: WKInterfaceController {
    
    override init() {
        super.init()
        setTitle("")
    }
    
    @IBAction func dismissButton() {
        dismissController()
    }

}
