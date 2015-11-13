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
    static let sharedInstance = SettingsData()
    
    var time  = 40 // Default time
    
    func setTimer(amount: Int) {
        time = amount
        print(time)
        
        
    }
    func getTimer() ->Int{
        return time
    }
    
}