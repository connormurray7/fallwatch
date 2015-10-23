//
//  SettingsData.swift
//  FallWatch
//
//  Created by Andrea Gines on 10/16/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import Foundation

class SettingsData
{
    var time  = 35 // Default time
    
    func setTimer(amount: Int) {
        time = amount
        print(time)
        
        
    }
    
}