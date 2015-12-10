//
//  AlertRequirement.swift
//  FallWatch
//
//  Created by Andrea Gines on 12/9/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import UIKit

class AlertRequirement: WKInterfaceController {
    
    override init() {
        super.init()
        setTitle("")
    }
    
    @IBAction func dismissButton() {
        dismissController()
    }

}
