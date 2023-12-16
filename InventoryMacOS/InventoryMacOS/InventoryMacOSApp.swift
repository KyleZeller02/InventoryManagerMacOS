//
//  InventoryMacOSApp.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import SwiftUI
import FirebaseCore // used for FirebaseApp.configure()

/// `InventoryMacOSApp` is the main entry point of the Inventory Management application for macOS.
/// This SwiftUI application is configured to use Firebase for backend services, including authentication.
///
/// - `@main`: Indicates that this is the starting point of the application.
/// - `@StateObject private var authViewModel`: An instance of `AdminOnboardingViewModel` is created and observed.
///   This object manages the authentication state and related logic throughout the application.
///     NOTE: authViewModel is defined here so that we can use the isAuthenticated variable to manage view transition form onboarding to dashboard view
///
/// The app's life cycle starts with the `init()` method, where Firebase is configured for use.
/// The `body` property defines the app's user interface. It uses a `WindowGroup` to create a new window for the app.
/// Based on the authentication state managed by `authViewModel`, the app decides which view to present:
/// - If the user is authenticated (`authViewModel.isAuthenticated` is `true`), `DashboardView` is presented,
///   showing the main dashboard of the application.
/// - If the user is not authenticated, `AdminDashboardLoginView` is presented, allowing the user to log in.
/// The `AdminDashboardLoginView` is provided with the `authViewModel` as an `@EnvironmentObject`,
/// allowing it to interact with and respond to the authentication state.
///
/// Usage:
/// - Run the application, and it will present the login view or the dashboard based on the user's authentication state.
/// - The authentication process is managed by `authViewModel`, and the view is updated accordingly to reflect the current state.
@main
struct InventoryMacOSApp: App {
    @StateObject private var authViewModel = AdminOnboardingViewModel()

    init (){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                DashboardView()
            } else {
                AdminDashboardLoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
