//
//  Items+CoreDataClass.swift
//  Calendar
//
//  Created by Zato on 11/15/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import Foundation
import CoreData


public class Items: NSManagedObject {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        name = ""
        budget = 0.00
        actual = 0.00
        deposit = 0.00
        balance = 0.00
        balanceDueDate = nil
        paidBy = ""
    }
}
