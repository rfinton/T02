//
//  ProtegeEvent.swift
//  T02_Yellow
//
//  Created by Zato on 11/6/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import Foundation

class ProtegeEvent {
    public var title: String?
    public var budget: Any?
    public var menu: Any?
    public var schedule: Any?
    public var contacts: [(name: String, phone: String)]
    
    init(title: String) {
        self.title = title
        self.budget = nil
        self.menu = nil
        self.schedule = nil
        self.contacts = []
    }
}
