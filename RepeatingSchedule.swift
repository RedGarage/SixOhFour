//
//  RepeatingSchedule.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData

class RepeatingSchedule: NSManagedObject {
    @NSManaged var endDate: NSDate
    @NSManaged var startDate: NSDate
    @NSManaged var schedule: NSManagedObject
}
