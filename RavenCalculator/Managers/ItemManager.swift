//
//  EquationManager.swift
//  RavenCalculator
//
//  Created by Robert Canton on 2020-03-12.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation


class ItemManager {
    
    static let shared = ItemManager()
    
    var items:[Item]
    private init() {
        // Mock Data
        items = []
    }
    
    func configure() {
        RavenAPI.shared.getItems { items in
            self.setItems(items)
        }
    }
    
    func addItem(_ item:Item) {
        
        let index = items.firstIndex {
            return $0.id == item.id
        }
        
        if index != nil {
            items[Int(index!)] = item
        } else {
            items.append(item)
        }
        
        itemsUpdated()
    }
    
    func setItems(_ items:[Item]) {
        self.items = items
        itemsUpdated()
    }
    
    private func itemsUpdated() {
        NotificationCenter.default.post(name: Notification.Name("itemsUpdated"), object: nil)
    }
}
