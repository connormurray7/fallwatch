//
//  ComplicationController.swift
//  FallWatch
//
//  Created by Evan Stoddard on 11/8/15.
//  Copyright © 2015 FallWatch. All rights reserved.
//

import WatchKit
import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.None])
    }
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimelineEntry?) -> Void) {
        
        var entry : CLKComplicationTimelineEntry?
        let now = NSDate()
        
        // create the template and timeline entry.
        if complication.family == .ModularSmall {
            
            let complicationTemplate = CLKComplicationTemplateModularSmallSimpleImage()
            let fwLogo = UIImage(named: "fallwatch_logo_58x58.png")
            assert(fwLogo != nil)
            complicationTemplate.imageProvider = CLKImageProvider(onePieceImage: fwLogo!)
            
            // create the entry.
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: complicationTemplate)
        }
        else {
            // ...configure entries for other complication families.
        }
        
        // pass the timeline entry back to ClockKit.
        handler(entry)
        
    }
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        print("getPlaceholderTemplateForComplication")
        let complicationTemplate = CLKComplicationTemplateModularSmallSimpleImage()
        let fwLogo = UIImage(named: "beer_glass")
        assert(fwLogo != nil)
        complicationTemplate.imageProvider = CLKImageProvider(onePieceImage: fwLogo!)
        handler(complicationTemplate)
    }
}
