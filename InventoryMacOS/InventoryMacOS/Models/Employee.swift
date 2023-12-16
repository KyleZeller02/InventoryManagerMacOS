//
//  User.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import Foundation



enum Role: String, Codable,CaseIterable {
    case partTime = "Part Time"
    case fullTime = "Full Time"
    case manager = "Manager"
}

struct Employee: Codable, Identifiable {
    var id: UUID = UUID()
    var storeId: String
    var employeeId: String
    var startDate: Date
    var role: Role
    
    var yearsOfWorking: Int {
        // Calculate years of work based on startDate
        Calendar.current.dateComponents([.year], from: startDate, to: Date()).year ?? 0
    }

    // Sample Employees
    static let sampleUsers: [Employee] = [
        Employee(storeId: "001", employeeId: "Alice Johnson", startDate: Calendar.current.date(byAdding: .year, value: -5, to: Date())!, role: .fullTime),
        Employee(storeId: "002", employeeId: "Bob Smith", startDate: Calendar.current.date(byAdding: .year, value: -3, to: Date())!, role: .partTime),
        Employee(storeId: "003", employeeId: "Charlie Davis", startDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!, role: .manager)
    ]

    // Implement a method to convert the struct into a dictionary
    func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        
        // Handle the date formatting for Firebase
        encoder.dateEncodingStrategy = .millisecondsSince1970
        
        do {
            let data = try encoder.encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dictionary ?? [:]
        } catch {
            print("Error encoding employee: \(error)")
            return [:]
        }
    }
}
