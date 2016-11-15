//
//  Budget.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit
import CoreData

class Budget {
    public var amount: Float
    public var spent: Float {
        didSet {
            self.remaining = self.amount - self.spent
        }
    }
    public var remaining: Float
    public var categories: [BudgetCategory]
    
    
    init() {
        self.amount = 0.00
        self.spent = 0.00
        self.remaining = 0.00
        self.categories = []
    }
}




class BudgetCategory {
    public var name: String
    public var items: [CategoryItem]
    
    
    init(_ name: String) {
        self.name = name
        self.items = []
    }
}




class CategoryItem {
    public var title: String
    public var budget: Float
    public var actual: Float
    public var depositPaid: Float
    public var balanceDue: Float
    public var balanceDueDate: Date?
    public var paidBy: String
    
    
    init(_ title: String) {
        self.title = title
        self.budget = 0.00
        self.actual = 0.00
        self.depositPaid = 0.00
        self.balanceDue = 0.00
        self.balanceDueDate = nil
        self.paidBy = ""
    }
}








