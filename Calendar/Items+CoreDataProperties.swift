//
//  Items+CoreDataProperties.swift
//  Calendar
//
//  Created by Zato on 11/15/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items");
    }

    @NSManaged public var name: String?
    @NSManaged public var budget: Float
    @NSManaged public var actual: Float
    @NSManaged public var deposit: Float
    @NSManaged public var balance: Float
    @NSManaged public var balanceDueDate: NSDate?
    @NSManaged public var paidBy: String?

}
