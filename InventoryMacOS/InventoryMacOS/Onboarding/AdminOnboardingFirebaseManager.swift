//
//  AdminOnboardingFirebaseManager.swift
//  InventoryMacOS
//
//  Created by Kyle Zeller on 12/15/23.
//

import Foundation
import Firebase

class AdminOnboardingFirebaseManager{
    static let shared = AdminOnboardingFirebaseManager()
    
    func login(email: String, password: String) async throws -> AuthDataResult {
            // Perform the login operation using Firebase Authentication
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return authResult
        }
    
}
