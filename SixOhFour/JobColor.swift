//
//  JobColor.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/15/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit

class JobColor: NSObject {
    
    func getJobColor(jobColor: String) -> UIColor {
        
        if jobColor == "Red" {
            return UIColor.redColor()
        } else if jobColor == "Blue" {
            return UIColor.blueColor()
        } else if jobColor == "Green" {
            return UIColor.greenColor()
        } else if jobColor == "Yellow" {
            return UIColor.yellowColor()
        } else if jobColor == "Purple" {
            return UIColor.purpleColor()
        } else {
            return UIColor.blackColor()
        }
    }
    
}
