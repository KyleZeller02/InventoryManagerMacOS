//
//  AdminOnboardingViewModel.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import Foundation

import Foundation


class AdminOnboardingViewModel: ObservableObject {
    // Assuming you have these properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let onboardingFirebase = AdminOnboardingFirebaseManager.shared
    
    var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")

    func handleLogin() async {
        // Reset error message
        DispatchQueue.main.async{
            self.errorMessage = nil
        }

        // Ensure input is valid
        guard validateInput() else { return }

        // Set loading flag
        isLoading = true

        do {
            // Attempt to login
            let authResult = try await onboardingFirebase.login(email: email, password: password)
            // Login was successful, update UserDefaults
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            isLoggedIn = true
            
        } catch {
            // Handle error
            DispatchQueue.main.async{
                self.errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }

        // Unset loading flag
        isLoading = false
    }

    private func validateInput() -> Bool {
        // Implement your input validation logic here
        // Return true if the input is valid, false otherwise
        // For example:
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and password must not be empty."
            return false
        }
        return true
    }
}





