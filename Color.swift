//
//  Color.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData
@objc(Color)


class Color: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var isSelected: NSNumber
    @NSManaged var job: Job
}
