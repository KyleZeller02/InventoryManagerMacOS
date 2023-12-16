//
//  DashBoardView.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView {
            UserAccountManagementView()
                .tabItem {
                    Text("Accounts")
                }

            InventoryManagementView()
                .tabItem {
                    Text("Inventory")
                }

            AnalyticsReportsView()
                .tabItem {
                    Text("Reports")
                }
        }
    }
}

#Preview {
    DashboardView()
}
