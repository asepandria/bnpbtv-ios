//
//  MenuSection.swift
//  BPNBTV
//
//  Created by Raditya on 6/12/17.
//  Copyright © 2017 Radith. All rights reserved.
//

import Foundation

struct MenuSection {
    var name: String!
    var items: [Menu]!
    var collapsed: Bool!
    
    init(name: String, items: [Menu], collapsed: Bool = true) {
        self.name = name
        self.items = items as [Menu]
        self.collapsed = collapsed
    }
}
