//
//  ContentView.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import SwiftUI

/// `AdminDashboardLoginView` is a SwiftUI view designed for the login screen of the "StoreMaster: Admin Dashboard" macOS app.
/// It presents a user interface for admin users to log in, featuring input fields for username and password, and a login button.
/// The view is styled specifically for a macOS desktop environment and adapts to the system's appearance settings (light or dark mode).
struct AdminDashboardLoginView: View {
    /// The view model handling the authentication logic.
    @EnvironmentObject var viewModel: AdminOnboardingViewModel

    /// Environment property to detect the current system appearance (light or dark mode).
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Displays an app-specific image or logo. The color of the image adapts to the system's color scheme.
            Image(systemName: "cube.box.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(colorScheme == .dark ? .gray : .blue) // Color adaptation

            // Title text for the app, styled with a large, bold font for visibility.
            Text("StoreMaster: Admin Dashboard")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .primary) // Text color adaptation
                .padding(.horizontal)

            // Username input field. Rounded border style is used for a cleaner, desktop-appropriate look.
            TextField("Username", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)

            // Password input field with secure text entry. Similar styling as username field for consistency.
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)

            // Login button. Executes the login process when clicked.
            Button("Login") {
                
                // made these variables in an attemp to get rid of accessing the variable on a background thread, seemed ineffective
                let localEmail = viewModel.email
                let localPassword = viewModel.password

                Task { // since handle login is async, must be put in a task (background thread)
                    await viewModel.handleLogin(email: localEmail, password: localPassword)
                }
            }
            .buttonStyle(PrimaryButtonStyle()) // Custom button style defined below for a distinctive macOS appearance
            .padding(.horizontal, 50)

            // Displays an error message if there is any during the login process.
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red) // Error message in red for clear visibility
                    .lineLimit(nil) // Allows for multiple lines if necessary
            }

            // Footer text, using a smaller font size for less emphasis.
            Text("Admin Dashboard for Inventory Management")
                .font(.footnote)
                .foregroundColor(colorScheme == .dark ? .gray : .secondary) // Text color adaptation

            Spacer()
        }
        .padding() // Outer padding for the entire VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures the VStack takes the full size of the window
    }
}

/// Custom Button Style specifically designed for macOS.
/// It gives a distinctive look to buttons, with a background color, text color, corner radius, and a slight scale effect on press.
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue) // Button background color
            .foregroundColor(.white) // Text color for the button
            .cornerRadius(8) // Rounded corners
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Slightly scales down when pressed
    }
}

#Preview {
    AdminDashboardLoginView()
}
