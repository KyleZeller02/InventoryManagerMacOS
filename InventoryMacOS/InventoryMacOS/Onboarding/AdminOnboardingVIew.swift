//
//  ContentView.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import SwiftUI

/// `AdminDashboardLoginView` is a SwiftUI view for the login screen of the macOS app "StoreMaster: Admin Dashboard".
/// This view includes input fields for username and password, a login button, and is styled for a macOS desktop environment.
struct AdminDashboardLoginView: View {
    /// The view model that handles the logic for logging into the admin dashboard.
    @StateObject var viewModel = AdminOnboardingViewModel()

    /// Environment property to detect the current appearance of the system (light or dark mode).
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // App logo or image, adapted for macOS.
            // The color adapts to the appearance: lighter color in dark mode and a darker color in light mode.
            Image(systemName: "cube.box.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(colorScheme == .dark ? .gray : .blue)

            // App title, with a larger font suitable for desktop.
            Text("StoreMaster: Admin Dashboard")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
                .padding(.horizontal)

            // Username input field, with a style more suited for desktop.
            TextField("Username", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)

            // Password input field, with similar desktop styling.
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)

            // Login button adapted for macOS.
            Button("Login") {
                Task {
                    await viewModel.handleLogin()
                }
            }
            .buttonStyle(PrimaryButtonStyle()) // Custom button style for macOS
            .padding(.horizontal, 50)

            // Error message display.
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            // Footer text adapted for desktop.
            Text("Admin Dashboard for Inventory Management")
                .font(.footnote)
                .foregroundColor(colorScheme == .dark ? .gray : .secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Custom Button Style for macOS.
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    AdminDashboardLoginView()
}
