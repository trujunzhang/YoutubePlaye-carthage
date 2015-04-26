//
//  NSDateExtensions.swift
//  YoutubePlayer
//
//  Created by Ryoichi Hara on 2015/04/08.
//  Copyright (c) 2015年 Ryoichi Hara. All rights reserved.
//

import Foundation


extension NSDate {
    
    func timeAgo() -> String {
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(name: "GMT")!
        
        let unitFlags: NSCalendarUnit =
            .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond
        let dateComponents = calendar.components(unitFlags, fromDate: self, toDate: currentDate, options: NSCalendarOptions.allZeros)
        
        // stackoverflow.com/questions/26277626/nslocalizedstring-with-swift-variable
        
        if dateComponents.day != 0 {
            return "\(dateComponents.day)d"
        }
        
        if dateComponents.hour != 0 {
            return "\(dateComponents.hour)h"
        }
        
        if dateComponents.minute != 0 {
            return "\(dateComponents.minute)min"
        }
        
        return "\(dateComponents.second)sec"
    }
}