//
//  InventoryMacOSApp.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import SwiftUI
import Firebase

@main
struct InventoryMacOSApp: App {
    init (){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            //if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                DashboardView()
           // } else {
             //   AdminDashboardLoginView()
            //}
        }
    }
}
