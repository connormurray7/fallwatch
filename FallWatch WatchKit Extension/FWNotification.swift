//
//  FWNotification.swift
//  FallWatch
//
//  Created by Andrea Gines on 11/3/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import Foundation

class FWNotification {
    
    private var time: Int
    
    init(FWTime: Int) {
        time = FWTime
    }
    
    // returns false if the user dismisses the alert, else returns true and notifies the user's emergency contacts
    func notifyUser() ->Bool{
        
        return false;
    }
    
    
}