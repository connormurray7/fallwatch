//
//  FWNotification.swift
//  FallWatch
//
//  Created by Andrea Gines on 11/3/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import Foundation
import WatchKit
import UIKit

class FWNotification {
    
    static let sharedInstance = FWNotification()
    
    private var time = 40
    private var seconds = 0
    private var timer = NSTimer()
    
    init() {
        print("Singleton init: time= \(time)")
    }
    

    
    
    func setTimer(FWTime: Int)
    {
        
        // assert illegal time
        time = FWTime
        print("New timer value= \(time)")
    }
    func getTimer() ->Int{
        return time;
    }
    
    
}
