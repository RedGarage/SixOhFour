//
//  Company.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import Foundation
import CoreData
@objc(Company)


class Company: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var jobs: NSSet
}
