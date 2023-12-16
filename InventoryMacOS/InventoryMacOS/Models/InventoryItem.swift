//
//  InventoryItem.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/16/23.
//

import Foundation
import SwiftUI

struct InventoryItem: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var image: Image
    var price: Double
    var count: Int
    var storeIds: Set<String> // Set of store IDs where the item is available

    static let sampleItems: [InventoryItem] = [
        InventoryItem(name: "Apples", description: "Fresh red apples", image: Image("apple"), price: 3.99, count: 30, storeIds: ["store1", "store2"]),
        InventoryItem(name: "Bread", description: "Whole grain bread", image: Image("bread"), price: 2.49, count: 20, storeIds: ["store1"]),
        InventoryItem(name: "Milk", description: "1 Gallon of Milk", image: Image("milk"), price: 2.99, count: 10, storeIds: ["store2"]),
        InventoryItem(name: "Eggs", description: "Dozen eggs", image: Image("eggs"), price: 2.99, count: 15, storeIds: ["store1", "store2"]),
        InventoryItem(name: "Cheese", description: "Cheddar cheese block", image: Image("cheese"), price: 5.49, count: 25, storeIds: ["store1"]),
    ]
}

