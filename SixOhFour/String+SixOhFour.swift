//
//  String+SixOhFour.swift
//  SixOhFour
//
//  Created by Chris Cruz on 7/31/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation

extension String {
    static func fractionsString(fractions: Int) -> String {
        return fractions > 9 ? "\(fractions)" : "0\(fractions)"
    }
    
    static func secondsString(seconds: Int) -> String  {
        return seconds > 9 ? "\(seconds)" : "0\(seconds)"
    }
    
    static func minutesString(minutes: Int) -> String  {
        return minutes > 9 ? "\(minutes)" : "0\(minutes)"
    }
    
    static func hoursString(hours: Int) -> String {
        return hours > 9 ? "\(hours)" : "0\(hours)"
    }
}