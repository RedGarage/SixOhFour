//
//  Shifts.swift
//  SixOhFour
//
//  Created by Joseph Pelina on 7/18/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import CoreData
@objc(Shifts)

class Shifts: NSManagedObject {
    
    @NSManaged var duration: Int16
    @NSManaged var jobName: String
    
}